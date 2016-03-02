require 'faker'

FactoryGirl.define do
  factory :position do
    title { Faker::Name.title }
    from { Faker::Time.between(5.months.ago, Time.now - 1.months, :all) }
    association :area, factory: :area
    association :holder, factory: :holder
  end
end
