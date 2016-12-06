require 'wikipedia'

class Composer < ApplicationRecord
  validates :wikipedia_page_name, presence: true
  validates :name, presence: true
  validates :short_name, presence: true

  has_many :composer_sources
  has_many :sources, through: :composer_sources

  before_validation :normalize_names
  before_validation :evaluate_importance

  def populate_dates!(force = false)
    if birth_year.nil? || death_year.nil? || force
      return unless page.summary.present?
      dates = page.summary.scan( /(\d\d\d\d).*?–.*?(\d\d\d\d)/ )[0]
      if dates && dates[0].present? && dates[1].present?
        update_attributes(birth_year: dates[0], death_year: dates[1])
      end
    end
  end

  def populate_wikipedia_page_length!(force = false)
    if wikipedia_page_length.nil? || force
      update_attributes(wikipedia_page_length: page.content.try(:length))
    end
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

  def evaluate_importance
    if importance.nil? || wikipedia_page_length_changed? || google_results_count_changed?
      self.importance = ImportanceEvaluation.new(self).importance
    end
  end

  def page
    @page ||= Wikipedia.find(wikipedia_page_name)
  end
end
