require 'faker'

FactoryGirl.define do
  factory :organization_registered_lobby do
    association :registered_lobby, factory: :registered_lobby
    association :organization, factory: :organization
  end
end
