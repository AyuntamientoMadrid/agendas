require 'faker'

FactoryGirl.define do
  factory :organization do
    reference { Faker::Number.number(8) }
    identifier { Faker::Number.number(10) }
    address_type { Faker::Address.street_suffix }
    address { Faker::Address.street_name }
    number { Faker::Address.building_number }
    stairs "Left"
    floor { rand(1..5) }
    door "A"
    postal_code { Faker::Address.postcode }
    town { Faker::Address.city }
    province { Faker::Address.state }
    phones { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    association :category, factory: :category
    web "www.organization.com"
    registered_lobbies :generalitat_catalunya
    fiscal_year 2018
    range_fund :range_1
    subvention false
    contract true
    denied_public_data false
    denied_public_events false

    trait :company do
      name { Faker::Company.name }
    end

    trait :person  do
      first_name { Faker::Name.first_name }
      last_name { Faker::Name.last_name }
    end

  end

end
