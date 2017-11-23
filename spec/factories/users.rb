require 'faker'

FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end

  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email
    password "please123"

    trait :admin do
      role "admin"
    end
    trait :user do
      role "user"
    end
    trait :lobby do
      role "lobby"
      phones "645586786"
      association :organization, factory: :organization
    end
  end
end
