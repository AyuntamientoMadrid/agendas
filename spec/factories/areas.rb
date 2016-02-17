require 'faker'

FactoryGirl.define do
  factory :area do
    title { Faker::Commerce.department(4, false) }
  end

end
