require 'rails_helper'

RSpec.describe Composer, type: :model do
  it { is_expected.to validate_presence_of :page_name }
  it { is_expected.to validate_presence_of :display_name }

  context 'given some composers' do
    let(:bach) do
      Composer.create({
        page_name: "Johann Sebastian Bach",
        display_name: "JS Bach",
        primary_era: "Baroque",
        birth_year: 1685,
        death_year: 1750,
        wikipedia_page_length: 137459,
        google_results_count: 15300000,
        gender: "M",
      })
    end

    let(:mozart) do
      Composer.create({
        page_name: "Wolfgang Amadeus Mozart",
        display_name: "Mozart",
        primary_era: "Classical",
        birth_year: 1756,
        death_year: 1791,
        wikipedia_page_length: 65478,
        google_results_count: 14200000,
        gender: "M",
      })
    end

    let(:beethoven) do
      Composer.create({
        page_name: "Ludwig van Beethoven",
        display_name: "Beethoven",
        primary_era: "Romantic",
        birth_year: 1770,
        death_year: 1827,
        wikipedia_page_length: 72456,
        google_results_count: 14300000,
        gender: "M",
      })
    end

    let(:palestrina) do
      Composer.create({
        id: 16,
        page_name: "Giovanni Pierluigi da Palestrina",
        display_name: "Palestrina",
        primary_era: "Renaissance",
        birth_year: 1525,
        death_year: 1594,
        wikipedia_page_length: 19360,
        google_results_count: 628000,
        gender: "M",
        created_at: "2016-11-26T01:35:57.144Z",
        updated_at: "2016-11-26T01:36:25.870Z"
      },
    end

    let(:sibelius) do
      Composer.create({
        id: 16,
        page_name: "Giovanni Pierluigi da Palestrina",
        display_name: "Palestrina",
        primary_era: "Renaissance",
        birth_year: 1525,
        death_year: 1594,
        wikipedia_page_length: 19360,
        google_results_count: 628000,
        gender: "M",
        created_at: "2016-11-26T01:35:57.144Z",
        updated_at: "2016-11-26T01:36:25.870Z"
      },
    end

    describe '#importance' do
      it 'returns a higher score for more important composers' do
        expect(beethoven.importance)
      end
    end
  end
end
