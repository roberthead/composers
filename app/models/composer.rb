require 'wikipedia'

class Composer < ApplicationRecord
  validates :wikipedia_page_name, presence: true
  validates :name, presence: true
  validates :short_name, presence: true

  before_validation :normalize_names

  def populate_dates!
    if birth_year.nil? || death_year.nil?
      dates = page.summary.scan( /(\d\d\d\d).*?–.*?(\d\d\d\d)/ )[0]
      if dates[0].present? and dates[1].present?
        update_attributes(birth_year: dates[0], death_year: dates[1])
      end
    end
  end

  def populate_wikipedia_page_length!
    update_attributes(wikipedia_page_length: page.content.length)
  end

  private

  def normalize_names
    self.name = wikipedia_page_name.to_s.gsub(' (composer)', '') if name.blank?
    names = name.split
    if short_name.blank? && name.present?
      if names[-2].to_s.downcase.in?(['de', 'da', 'des', 'of'])
        self.short_name = name
      else
        self.short_name = name.split.last
      end
    end
  end

  def page
    @page ||= Wikipedia.find(wikipedia_page_name)
  end
end
