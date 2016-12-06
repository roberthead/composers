require 'rails_helper'

RSpec.describe ComposerSource, type: :model do
  it { is_expected.to belong_to :composer }
  it { is_expected.to belong_to :source }

  it { is_expected.to validate_presence_of :composer }
  it { is_expected.to validate_presence_of :source }
end
