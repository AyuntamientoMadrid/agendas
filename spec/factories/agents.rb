require 'faker'

FactoryGirl.define do

  factory :agent do
    identifier { Faker::Number.number(10) }
    name { Faker::Name.first_name }
    first_surname { Faker::Name.last_name }
    second_surname { Faker::Name.last_name }
    from Time.zone.yesterday
    public_assignments "text"
    allow_public_data true
    association :organization, factory: :organization
  end

end
