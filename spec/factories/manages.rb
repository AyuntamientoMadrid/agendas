FactoryGirl.define do
  factory :manage do
    association :user
    association :holder
  end

end
