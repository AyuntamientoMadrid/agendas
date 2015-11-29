FactoryGirl.define do
  factory :participant do
    association :position
    association :event
  end
end
