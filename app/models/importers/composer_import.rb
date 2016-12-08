require 'wikipedia'
require 'csv'

class ComposerImport
  attr_reader :wikipedia_page, :page_title, :source

  ERA_PAGES = %w{List_of_medieval_composers List_of_Renaissance_composers List_of_Baroque_composers List_of_Classical-era_composers List_of_Romantic-era_composers List_of_20th-century_classical_composers}

  DEFAULT_PAGE_TITLE = 'List_of_classical_music_composers_by_era'

  delegate :content, to: :wikipedia_page

  def self.import_all_wikipedia_pages!
    new.import!
    ERA_PAGES.each do |era_page|
      new(era_page).import!
    end
  end

  def initialize(page_title = DEFAULT_PAGE_TITLE)
    @page_title = page_title
    @wikipedia_page = Wikipedia.find(page_title)
    @source = Source.where(url: wikipedia_page.fullurl).first_or_create
  end

  def import!
    ensure_composers
    load_genders!
    Composer.where(birth_year: nil, death_year: nil).find_each(&:populate_dates!)
    Composer.where(wikipedia_page_length: 0).find_each(&:populate_wikipedia_page_length!)
    Composer.where(wikipedia_page_length: nil).find_each(&:populate_wikipedia_page_length!)
  end

  def ensure_composers
    ensure_composers_from_timeline_tables
    ensure_composers_from_table_list
    ensure_composers_from_simple_list
  end

  def ensure_composers_from_timeline_tables
    Era.all.each do |era|
      era_color = era.name.first(3)
      regex = /color:#{era_color}\s+text:\[\[(.+?)\]\]/mi
      content.scan(regex).each do |composer_link|
        page_name, short_name = composer_link[0].split(/\|/)
        short_name ||= page_name
        Composer.where(wikipedia_page_name: page_name).first_or_initialize.tap do |composer|
          composer.update_attributes(short_name: short_name, primary_era: era.name)
          ComposerSource.where(composer: composer, source: source, era: era.name).first_or_create.touch
        end
      end
    end
  end

  def ensure_composers_from_table_list
    regex = /^\|'?'?\[\[([^\]|]*)\|?(.*)?\]\].*\|\|(.*)\|\|(.*)\|\|(.*)/
    era = Era.from_string(page_title).name
    content.scan(regex).each do |composer_record|
      wikipedia_page_name, short_name, birth, death = composer_record
      birth_year = date_from_string(birth)
      death_year = date_from_string(death)
      Composer.where(wikipedia_page_name: wikipedia_page_name).first_or_initialize.tap do |composer|
        composer.short_name = short_name if composer.short_name.blank? && short_name.present?
        composer.birth_year ||= birth_year
        composer.death_year ||= death_year
        composer.save
        ComposerSource.where(composer: composer, source: source, era: era).first_or_create.touch
      end
    end
  end

  def ensure_composers_from_simple_list
    regex = /^\*\s*'?'?\[\[([^\]|]*)\|?(.*)?\]\].*\b(\d\d\d\d*)\b.*\b(\d\d\d\d*)\b/
    era = Era.from_string(page_title).name
    content.scan(regex).each do |composer_record|
      wikipedia_page_name, short_name, birth, death = composer_record
      birth_year = date_from_string(birth)
      death_year = date_from_string(death)
      Composer.where(wikipedia_page_name: wikipedia_page_name).first_or_initialize.tap do |composer|
        composer.short_name = short_name if composer.short_name.blank? && short_name.present?
        composer.birth_year ||= birth_year
        composer.death_year ||= death_year
        composer.save
        ComposerSource.where(composer: composer, source: source, era: era).first_or_create.touch
      end
    end
  end

  def load_genders!
    female_composers_content = page_of_female_composers.content
    Composer.where(gender: nil).find_each do |composer|
      gender = female_composers_content.include?(composer.name) ? 'F' : 'M'
      composer.update_attributes(gender: gender)
    end
  end

  private

  def date_from_string(string)
    match = string.scan(/\d\d\d\d/)
    return match.first.to_i if match.first.present?
    match = string.scan(/\d\d\d/)
    return match.first.to_i if match.first.present?
    match = string.scan(/(\d+)th\s+cen/).dig(0, 0)
    return (match.to_i - 1) * 100 if match.present?
  end

  def page_of_female_composers
    @page_of_female_composers ||= Wikipedia.find('List of female composers by birth date')
  end
end
