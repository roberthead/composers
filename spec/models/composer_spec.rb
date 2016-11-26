require 'rails_helper'

RSpec.describe Composer, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :wikipedia_page_name }
  it { is_expected.to validate_presence_of :short_name }

  context 'given some composers' do
    let!(:bach) do
      Composer.create({
        wikipedia_page_name: "Johann Sebastian Bach",
        short_name: "JS Bach",
        primary_era: "Baroque",
        birth_year: 1685,
        death_year: 1750,
        wikipedia_page_length: 137459,
        google_results_count: 15300000,
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
        google_results_count: 14200000,
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
        google_results_count: 14300000,
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
        google_results_count: 628000,
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
        google_results_count: 237000,
        gender: "M",
      })
    end

    describe '#importance' do
      it 'returns a higher score for more important composers' do
        expect(beethoven.importance).to be > sibelius.importance
      end
    end
  end
end
