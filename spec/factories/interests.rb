FactoryGirl.define do

  factory :interest do
    sequence(:name) { |n| "Interest #{n}" }
  end

end
