require 'wikipedia'
require 'csv'

class ComposerImport
  attr_reader :wikipedia_page, :page_title

  DEFAULT_PAGE_TITLE = 'List_of_classical_music_composers_by_era'

  delegate :content, to: :wikipedia_page

  def initialize(page_title = DEFAULT_PAGE_TITLE)
    @page_title = page_title
    @wikipedia_page = Wikipedia.find(page_title)
  end

  def import!
    ensure_composers
    load_google_results_counts!
    load_genders!
    composers = Composer.all
    composers.each(&:populate_dates!)
    composers.each(&:populate_wikipedia_page_length!)
  end

  def ensure_composers
    ensure_composers_from_timeline_tables
    ensure_composers_from_table_list
  end

  def ensure_composers_from_timeline_tables
    regex = /color:#{era.color}\s+text:\[\[(.+?)\]\]/mi
    Era.all.each do |era|
      content.scan(regex).each do |composer_link|
        page_name, short_name = composer_link[0].split(/\|/)
        short_name ||= page_name
        Composer.where(wikipedia_page_name: page_name).first_or_initialize do |composer|
          composer.update_attributes(short_name: short_name, primary_era: era.name)
        end
      end
    end
  end

  def ensure_composers_from_table_list
    regex = /^\|'?'?\[\[([^\]|]*)\|?(.*)?\]\](.*)\|\|(.*)\|\|(.*)\|\|(.*)/
    era = Era.from_string(page_title).name
    content.scan(regex).each do |composer_record|
      wikipedia_page_name, name, birth, death = composer_record
      birth_year = date_from_string(birth)
      death_year = date_from_string(death)
      Composer.where(wikipedia_page_name: wikipedia_page_name).first_or_initialize do |composer|
        composer.short_name = short_name if composer.short_name.blank?
        composer.name = name if composer.name.blank?
        composer.birth_year ||= birth_year
        composer.death_year ||= death_year
        composer.save
        p composer
      end
    end
  end

  def load_google_results_counts!
    results_counts_filepath = Rails.root.join('db', 'seed_data', 'composer_google_results.csv').to_s
    CSV.foreach(results_counts_filepath, headers: true, header_converters: :symbol) do |row|
      composer = Composer.where(name: row[:name]).first
      if composer
        composer.update_attributes(google_results_count: row[:google_results_count])
      end
    end
  end

  def load_genders!
    Composer.find_each do |composer|
      gender = page_of_female_composers.content.include?(composer.name) ? 'F' : 'M'
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

class Era
  ERAS = %w{Medieval Renaissance Baroque Classical Romantic Modernist}

  def self.all
    ERAS.map { |era| new(era) }
  end

  def self.from_string(string)
    self.all.detect { |era| string.scan(/#{era.name}/i).present? }
  end

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def color
    name.first(3)
  end
end
