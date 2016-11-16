require 'faker'

FactoryGirl.define do
  factory :event do
    title "Event title"
    description "Event description"
    scheduled Time.now
    association :position, factory: :position
    association :user, factory: :user
  end
end
