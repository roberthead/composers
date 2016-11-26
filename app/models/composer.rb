require 'wikipedia'

class Composer < ApplicationRecord
  validates :wikipedia_page_name, presence: true
  validates :name, presence: true
  validates :short_name, presence: true

  before_validation :normalize_names

  def populate_dates!
    if birth_year.nil? || death_year.nil?
      dates = page.summary.scan( /(\d\d\d\d).*?–.*?(\d\d\d\d)/ )[0]
      if dates.present?
        update_attributes(birth_year: dates[0], death_year: dates[1])
      end
    end
  end

  def populate_wikipedia_page_length!
    update_attributes(wikipedia_page_length: page.content.length)
  end

  def importance
    google_results_count ** 0.25 + wikipedia_page_length ** 0.25
  end

  def bio
    "#{name} (#{lifespan})"
  end

  def lifespan
    "#{birth_year}–#{death_year}"
  end

  private

  def normalize_names
    self.name ||= wikipedia_page_name.to_s.gsub(' (composer)', '')
    self.short_name ||= name.split.last
  end

  def page
    @page ||= Wikipedia.find(wikipedia_page_name)
  end
end
