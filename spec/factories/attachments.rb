require 'faker'

FactoryGirl.define do
  factory :attachment do
    title { Faker::Lorem.sentence(3) }
    file { File.new("#{Rails.root}/spec/support/fixtures/image.jpg") }
    public true
  end

end
