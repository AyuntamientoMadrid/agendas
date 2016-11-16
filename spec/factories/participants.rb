require 'faker'

FactoryGirl.define do
  factory :participant do
    association :position, factory: :position
    association :participants_event, factory: :event
  end
end
