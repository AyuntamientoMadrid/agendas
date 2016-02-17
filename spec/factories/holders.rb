require 'faker'

FactoryGirl.define do
  factory :holder do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    #positions { |d| [d.association(:position)] }
  end
end
