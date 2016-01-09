FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end

  factory :user do
    first_name "Test"
    last_name "User"
    email
    password "please123"

    trait :admin do
      role 'admin'
    end
  end
end

