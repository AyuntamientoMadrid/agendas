require 'faker'

FactoryGirl.define do
  factory :event do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph(6, false, 2) }
    scheduled { rand(0..1)==1 ? Faker::Time.forward(60, :day) : Faker::Time.backward(100, :morning) }
    association :position, factory: :position
    association :user, factory: :user
  end
end
