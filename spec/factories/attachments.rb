require 'faker'

FactoryGirl.define do
  factory :attachment do
    title { Faker::Lorem.sentence(3) }
    file { File.new(Rails.root.join('spec', 'support', 'fixtures', 'image.jpg')) }
    public true
    description { Faker::Lorem.sentence(3) }
  end

end
