require 'faker'

FactoryGirl.define do
  factory :position do
    title { Faker::Name.title }
    association :area, factory: :area
    association :holder, factory: :holder
  end
end
