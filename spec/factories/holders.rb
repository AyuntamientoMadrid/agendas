FactoryGirl.define do
  factory :holder do
    first_name "First"
    last_name "Last"
    positions { |d| [d.association(:position)] }
  end
end
