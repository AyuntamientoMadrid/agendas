FactoryGirl.define do
  factory :newsletter do
    interest
    sequence(:subject) { |n| "Subject #{n}" }
    sequence(:body)    { |n| "Body #{n}" }
  end
end
