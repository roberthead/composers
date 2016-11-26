require 'wikipedia'

class Composer < ApplicationRecord
  validates :page_name, presence: true

  before_validation :ensure_display_name

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

  def populate_google_results_count!
  end

  def to_s
    bio
  end

  def bio
    "#{full_name} (#{life})"
  end

  def full_name
    page_name.gsub(/\s*\(\w+\)/, '')
  end

  def life
    "#{birth_year}–#{death_year}"
  end

  private

  def ensure_display_name
    self.display_name = page_name if display_name.blank?
  end

  def page
    @page ||= Wikipedia.find(page_name)
  end
end
