require 'faker'

FactoryGirl.define do
  factory :organization_interest do
    association :interest, factory: :interest
    association :organization, factory: :organization
  end
end
