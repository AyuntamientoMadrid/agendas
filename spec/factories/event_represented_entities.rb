FactoryGirl.define do

  factory :event_represented_entity do
    sequence(:name) { |n| "Represented entity name #{n}" }
    association :event
  end

end
