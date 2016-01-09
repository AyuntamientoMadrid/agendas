FactoryGirl.define do
  factory :position do
    title "Position title"
    from "2015-09-28 18:30:24"
    association :area, factory: :area
  end
end
