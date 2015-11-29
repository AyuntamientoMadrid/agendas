FactoryGirl.define do
  factory :position do
    title "MyString"
    from "2015-09-28 18:30:24"
    to "2015-09-28 18:30:24"
    association :area
    association :holder
  end

end
