FactoryGirl.define do
  factory :manage do
    association :user, factory: :user
    association :holder, factory: :holder
  end

end
