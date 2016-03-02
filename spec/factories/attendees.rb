require 'faker'

FactoryGirl.define do
  factory :attendee do
    name { Faker::Name.name }
    position { Faker::Name.title }
    company { Faker::Company.name }
  end
end
