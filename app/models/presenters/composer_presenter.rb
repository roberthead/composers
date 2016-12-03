class ComposerPresenter
  attr_reader :composer

  delegate :name, :short_name, to: :composer
  delegate :primary_era, :birth_year, :death_year, :gender, to: :composer
  delegate :wikipedia_page_name, :wikipedia_page_length, :google_results_count, to: :composer

  def initialize(composer)
    @composer = composer
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
end
