FactoryGirl.define do
  factory :newsletter do
    sequence(:subject) { |n| "Subject #{n}" }
    sequence(:body)    { |n| "Body #{n}" }
  end
end
