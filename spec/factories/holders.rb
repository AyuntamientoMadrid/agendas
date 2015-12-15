FactoryGirl.define do
  factory :holder do
    first_name "First"
    last_name "Last"
    before(:create) do |h|
      FactoryGirl.create(:position, holder: h)
    end
  end

end
