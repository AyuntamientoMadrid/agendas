require 'faker'

FactoryGirl.define do
  factory :event do
    title "Event title"
    description "Event description"
    lobby_activity false
    published_at Date.current
    scheduled Time.now
    location "Ayuntamiento de Madrid"
    association :position, factory: :position
    association :user, factory: :user
    association :organization, factory: :organization

  end

end
