require 'faker'

FactoryGirl.define do
  factory :question do
    title { Faker::Name.title }
    answer { Faker::Lorem.paragraph }
  end
end
