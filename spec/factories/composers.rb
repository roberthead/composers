FactoryGirl.define do
  factory :composer do
    wikipedia_page_name { [FFaker::Name.first_name, FFaker::Name.last_name].join(' ') }

    trait :with_data do
      primary_era { ([nil] + Era::ERAS).sample }
      birth_year { rand(1000) + 1000 if rand > 0.5 }
      death_year { |c| c.birth_year + rand(80) + 15 }
      wikipedia_page_length { (rand(400)+10) ** 2 if rand > 0.5 }
      google_results_count { (rand(1000)+10) ** 2 if rand > 0.5 }
    end
  end
end
