require 'wikipedia'

class Composer < ApplicationRecord
  validates :wikipedia_page_name, presence: true
  validates :name, presence: true
  validates :short_name, presence: true

  has_many :composer_sources
  has_many :sources, through: :composer_sources
  has_many :google_counts, -> { order :updated_at }

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

  def populate_google_results_count!(force = false)
    if google_results_count.nil? || force
      update_attributes(google_results_count: google_counts.last.try(:results_count))
    end
  end

  def fetch_google_results_count!
    GoogleFetch.new(self).fetch!
    populate_google_results_count!(:force)
  end

  private

  def normalize_names
    self.name = wikipedia_page_name.to_s.gsub(/ \(.+\)/, '') if name.blank?
    self.short_name = nil if short_name && short_name.scan(']]').present?
    if short_name.blank? && name.present?
      names = name.split
      if names[-2].to_s.downcase.in?(['de', 'da', 'des', 'of', 'the'])
        self.short_name = name
      elsif names[-1].in?(%w{I II III IV V VI VII VIII IX X XI XII XIII XIV XV})
        self.short_name = name
      elsif names[-1] == "Bach"
        self.short_name = names[0..-2].map { |name| name.first }.join('') + " Bach"
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
