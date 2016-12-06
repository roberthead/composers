class ImportanceEvaluation < Struct.new(:composer)
  delegate :google_results_count, :wikipedia_page_length, :sources, to: :composer

  GOOGLE_RESULTS_COUNT_EXPONENT = 0.23
  WIKIPEDIA_PAGE_LENGTH_EXPONENT = 0.25
  SOURCES_FACTOR = 2

  def importance
    (google_results_count || 0) ** GOOGLE_RESULTS_COUNT_EXPONENT +
    (wikipedia_page_length || 0) ** WIKIPEDIA_PAGE_LENGTH_EXPONENT +
    sources.length * SOURCES_FACTOR
  end
end
