FactoryGirl.define do

  factory :event_agent do
    sequence(:name) { |n| "Agent name #{n}" }
    association :event
  end

end
