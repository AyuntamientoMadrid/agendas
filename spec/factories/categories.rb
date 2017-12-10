FactoryGirl.define do

  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    display true
  end

end
