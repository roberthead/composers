require 'rails_helper'

RSpec.describe ImportanceEvaluation do
  context 'given some composers' do
    let!(:bach) do
      Composer.create({
        wikipedia_page_name: "Johann Sebastian Bach",
        short_name: "JS Bach",
        primary_era: "Baroque",
        birth_year: 1685,
        death_year: 1750,
        wikipedia_page_length: 137459,
        google_results_count: 484_000,
        gender: "M",
      })
    end

    let!(:mozart) do
      Composer.create({
        wikipedia_page_name: "Wolfgang Amadeus Mozart",
        short_name: "Mozart",
        primary_era: "Classical",
        birth_year: 1756,
        death_year: 1791,
        wikipedia_page_length: 65478,
        google_results_count: 8_410_000,
        gender: "M",
      })
    end

    let!(:beethoven) do
      Composer.create({
        wikipedia_page_name: "Ludwig van Beethoven",
        short_name: "Beethoven",
        primary_era: "Romantic",
        birth_year: 1770,
        death_year: 1827,
        wikipedia_page_length: 72456,
        google_results_count: 494_000,
        gender: "M",
      })
    end

    let!(:palestrina) do
      Composer.create({
        wikipedia_page_name: "Giovanni Pierluigi da Palestrina",
        short_name: "Palestrina",
        primary_era: "Renaissance",
        birth_year: 1525,
        death_year: 1594,
        wikipedia_page_length: 19360,
        google_results_count: 52_300,
        gender: "M",
      })
    end

    let!(:sibelius) do
      Composer.create({
        wikipedia_page_name: "Jean Sibelius",
        short_name: "Sibelius",
        primary_era: "Modernist",
        birth_year: 1865,
        death_year: 1957,
        wikipedia_page_length: 90695,
        google_results_count: 237_000,
        gender: "M",
      })
    end

    describe '#importance' do
      it 'returns a higher score for more important composers' do
        expect(ImportanceEvaluation.new(beethoven).importance).to be > ImportanceEvaluation.new(sibelius).importance
      end

      it 'returns a significantly higher score for more important composers' do
        expect(ImportanceEvaluation.new(bach).importance / ImportanceEvaluation.new(palestrina).importance).to be > 1.5
      end

      it 'returns a higher score with more sources' do
        expect(ImportanceEvaluation::SOURCES_FACTOR).to be > 0
        expect {
          FactoryGirl.create(:composer_source, composer: sibelius)
        }.to change {
          ImportanceEvaluation.new(sibelius.reload).importance
        }.by(ImportanceEvaluation::SOURCES_FACTOR)
      end
    end
  end
end
