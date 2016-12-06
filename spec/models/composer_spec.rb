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
end
