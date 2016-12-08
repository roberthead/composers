require 'rails_helper'

RSpec.describe Era, type: :model do
  describe '.from_string' do
    specify { expect(Era.from_string('List_of_Renaissance_composers').name).to eq "Renaissance" }
    specify { expect(Era.from_string('List_of_20th-century_classical_composers').name).to eq "Modernist" }
  end
end
