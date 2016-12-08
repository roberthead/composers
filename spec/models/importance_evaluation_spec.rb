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

      context 'for royalty' do
        let(:henry) do
          Composer.create({
            "name": "Henry VIII of England",
            "short_name": "Henry VIII of England",
            "wikipedia_page_name": "Henry VIII of England",
            "primary_era": "Renaissance",
            "birth_year": 1491,
            "death_year": 1547,
            "wikipedia_page_length": 126536,
            "google_results_count": 73800,
            "gender": "M",
          })
        end

        let(:frederick) do
          Composer.create({
            "name": "Frederick the Great",
            "short_name": "Frederick the Great",
            "wikipedia_page_name": "Frederick the Great",
            "primary_era": "Classical",
            "birth_year": 1712,
            "death_year": 1786,
            "wikipedia_page_length": 121204,
            "google_results_count": 258000,
            "gender": "M",
          })
        end

        let(:williams) do
          Composer.create({
            "name": "Ralph Vaughan Williams",
            "short_name": "R Vaughan Williams",
            "wikipedia_page_name": "Ralph Vaughan Williams",
            "primary_era": "Modernist",
            "birth_year": 1872,
            "death_year": 1958,
            "wikipedia_page_length": 98269,
            "google_results_count": 504100,
            "gender": "M",
          })
        end

        let(:salieri) do
          Composer.create({
            "name": "Antonio Salieri",
            "short_name": "Salieri",
            "wikipedia_page_name": "Antonio Salieri",
            "primary_era": "Classical",
            "birth_year": 1750,
            "death_year": 1825,
            "wikipedia_page_length": 54132,
            "google_results_count": 287100,
            "gender": "M",
          })
        end


        it 'returns a lower score' do
          expect(ImportanceEvaluation.new(salieri).importance / ImportanceEvaluation.new(henry).importance).to be > 1.5
          expect(ImportanceEvaluation.new(williams).importance / ImportanceEvaluation.new(frederick).importance).to be > 1.5
        end
      end
    end
  end
end
