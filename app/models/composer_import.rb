require 'wikipedia'
require 'csv'

class ComposerImport
  attr_reader :list_page

  def initialize
    @list_page = Wikipedia.find('List_of_classical_music_composers_by_era')
    ensure_composers
    load_google_results_counts!
    load_genders!
    composers = Composer.all
    composers.each(&:populate_dates!)
    composers.each(&:populate_wikipedia_page_length!)
  end

  def ensure_composers
    Era.all.each do |era|
      list_page.content.scan(/color:#{era.color}\s+text:\[\[(.+?)\]\]/mi).each do |composer_link|
        page_name, short_name = composer_link[0].split(/\|/)
        short_name ||= page_name
        Composer.where(wikipedia_page_name: page_name).first_or_initialize do |composer|
          composer.update_attributes(short_name: short_name, primary_era: era.name)
        end
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

  def page_of_female_composers
    @page_of_female_composers ||= Wikipedia.find('List of female composers by birth date')
  end
end

class Era
  ERAS = %w{Renaissance Baroque Classical Romantic Modernist}

  def self.all
    ERAS.map { |era| new(era) }
  end

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def color
    name.first(3)
  end
end
