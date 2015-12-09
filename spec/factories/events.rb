FactoryGirl.define do
  factory :event do
    title "MyString"
    description "MyText"
    scheduled "2015-09-23 15:48:11"
    association :position
  end

  trait :user do
    user :user
  end

end
