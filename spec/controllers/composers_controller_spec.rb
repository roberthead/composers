require 'rails_helper'

RSpec.describe ComposersController, type: :controller do
  describe "#index" do
    def make_request
      get :index, format: :json
    end

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

    it "returns composers" do
      bach; beethoven; mozart
      make_request
      expect(response).to be_success
      body = JSON.parse(response.body).with_indifferent_access
      composers = body[:composers]
      expect(composers.length).to eq 3
      last = composers.last
      expect(last["display_name"]).to eq "Beethoven"
    end
  end
end
