require 'rails_helper'

RSpec.describe Composer, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :wikipedia_page_name }
  it { is_expected.to validate_presence_of :short_name }

  describe '#importance' do
    let(:composer) { FactoryGirl.create(:composer, wikipedia_page_length: 10000) }

    it 'rises with wikipedia_page_length' do
      original_importance = composer.importance
      composer.update_attributes(wikipedia_page_length: composer.wikipedia_page_length * 2)
      expect(composer.importance).to be > original_importance
    end

    it 'rises with google_results_count' do
      original_importance = composer.importance
      composer.update_attributes(google_results_count: 5000)
      expect(composer.importance).to be > original_importance
    end

    it 'rises with sources count' do
      original_importance = composer.importance
      FactoryGirl.create(:composer_source, composer: composer)
      expect(composer.reload.importance).to be > original_importance
    end
  end

  describe 'name normalization' do
    describe 'short_name normalization' do
      it 'defaults to the last name' do
        composer = FactoryGirl.build(:composer, wikipedia_page_name: "Gordon Sumner")
        expect { composer.valid? }.to change { composer.short_name }.to("Sumner")
      end

      it 'handles Bach family members' do
        composer = FactoryGirl.build(:composer, wikipedia_page_name: "Carl Philipp Emanuel Bach")
        expect { composer.valid? }.to change { composer.short_name }.to("CPE Bach")
      end

      it 'recognizes locations' do
        composer = FactoryGirl.build(:composer, wikipedia_page_name: "Henry VIII of England")
        expect { composer.valid? }.to change { composer.short_name }.to("Henry VIII of England")
      end

      it 'recognizes honoraria' do
        composer = FactoryGirl.build(:composer, wikipedia_page_name: "Alexander the Great")
        expect { composer.valid? }.to change { composer.short_name }.to("Alexander the Great")
      end

      it 'recognizes royalty' do
        composer = FactoryGirl.build(:composer, wikipedia_page_name: "Henry VIII")
        expect { composer.valid? }.to change { composer.short_name }.to("Henry VIII")
      end

      it 'handles section links' do
        composer = FactoryGirl.build(:composer, wikipedia_page_name: "Leopold I, Holy Roman Emperor#Music")
        expect { composer.valid? }.to change { composer.name }.to("Leopold I, Holy Roman Emperor")
      end
    end
  end
end
