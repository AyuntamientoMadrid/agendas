FactoryGirl.define do
  factory :registered_lobby do
    name "Generalitat Catalunya"
    association :organization, factory: :organization
  end
end
