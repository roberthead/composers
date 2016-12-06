require 'rails_helper'

RSpec.describe Source, type: :model do
  specify { is_expected.to validate_presence_of(:url) }
end
