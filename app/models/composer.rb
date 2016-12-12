require 'wikipedia'

class Composer < ApplicationRecord
  validates :wikipedia_page_name, presence: true
  validates :name, presence: true
  validates :short_name, presence: true, uniqueness: true

  has_many :composer_sources
  has_many :sources, through: :composer_sources
  has_many :google_counts, -> { order :updated_at }

  before_validation :normalize_names
  before_validation :evaluate_importance

  def self.by_name(name)
    Composer
      .where(transliterated_name: I18n.transliterate(name))
      .or(Composer.where(transliterated_short_name: name))
      .first
  end

  def populate_dates!(force = false)
    if birth_year.nil? || death_year.nil? || force
      return unless page.summary.present?
      p page.summary
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
    # extract name from wikipedia page name
    self.name = name.presence || wikipedia_page_name.to_s.gsub(/ \(.+\)/, '')
    # remove section header from name
    self.name.gsub!(/#\w+/, '')
    # delete short_name if it contains bad characters
    self.short_name = nil if short_name.try(:scan, ']]').present?
    if name.present?
      # assign simplified name
      self.transliterated_name = I18n.transliterate(name)
      # deduce short name from name
      if short_name.blank?
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
      # assign simplified short name
      self.transliterated_short_name = I18n.transliterate(short_name)
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
