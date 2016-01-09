FactoryGirl.define do
  factory :participant do
    association :position, factory: :position
    association :event, factory: :event
  end
end
