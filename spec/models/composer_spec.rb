require 'rails_helper'

RSpec.describe Composer, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :wikipedia_page_name }
  it { is_expected.to validate_presence_of :short_name }
end
