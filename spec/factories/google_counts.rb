FactoryGirl.define do
  factory :google_count do
    results_count { rand(100000) }
    composer
  end
end
