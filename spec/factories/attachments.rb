require 'faker'

FactoryGirl.define do
  factory :attachment do
    title { Faker::Lorem.sentence(3) }
  end

end
