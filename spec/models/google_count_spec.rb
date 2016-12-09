require 'rails_helper'

RSpec.describe GoogleCount, type: :model do
  it { is_expected.to validate_presence_of :results_count }
  it { is_expected.to validate_presence_of :composer }
  it { is_expected.to validate_numericality_of(:results_count).only_integer.is_greater_than_or_equal_to(0) }
end
