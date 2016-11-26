require 'rails_helper'

RSpec.describe Composer, type: :model do
  it { is_expected.to validate_presence_of :page_name }
  it { is_expected.to validate_presence_of :display_name }
end
