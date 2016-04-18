require 'faker'

FactoryGirl.define do
  factory :event do
    #title { Faker::Lorem.sentence }
    #description { Faker::Lorem.paragraph(6, false, 2) }
    #scheduled { rand(0..1)==1 ? Faker::Time.forward(60, :day) : Faker::Time.backward(100, :morning) }
    title "Event title"
    description "Event description"
    scheduled "2015-09-23 15:48:11"
    association :position, factory: :position
    association :user, factory: :user
  end
end
