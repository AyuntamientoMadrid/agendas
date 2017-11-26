require 'faker'

FactoryGirl.define do
  factory :organization do
    name { Faker::Name.name }
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
    association :user, factory: :user
    web "www.organization.com"
    registered_lobbies :generalitat_catalunya
    fiscal_year 2018
    range_fund :range_1
    subvention false
    contract true
    denied_public_data false
    denied_public_events false
    entity_type :lobby
    inscription_date { Date.current }
    invalidate false

    trait :company do
      name { Faker::Company.name }
    end

    trait :lobby do
      entity_type :lobby
    end

    trait :association do
      entity_type :association
    end

    trait :federation do
      entity_type :federation
    end

    trait :person do
      name { Faker::Name.name }
      first_surname { Faker::Name.last_name }
      second_surname { Faker::Name.last_name }
    end

  end

end
