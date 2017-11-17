require 'faker'

FactoryGirl.define do

  factory :holder do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }

    trait :with_position do
      after :create do |holder|
        create(:position, holder: holder)
      end
    end
  end

end
