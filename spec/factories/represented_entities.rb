require 'faker'

FactoryGirl.define do
  factory :represented_entity do
    identifier { Faker::Number.number(10) }
    name { Faker::Name.first_name }
    first_surname { Faker::Name.last_name }
    second_surname { Faker::Name.last_name }
    from Time.zone.yesterday
    to Time.zone.today
    fiscal_year 2018
    range_fund :range_1
    subvention false
    contract true
    association :organization, factory: :organization
  end

end
