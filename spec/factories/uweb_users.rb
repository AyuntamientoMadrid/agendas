require 'faker'

FactoryGirl.define do
  factory :uweb_user, class:Array do
    skip_create
    CLAVE_IND '00001'
    NOMBRE_USUARIO { Faker::Name.first_name }
    APELLIDO1_USUARIO { Faker::Name.last_name }
    APELLIDO2_USUARIO { Faker::Name.last_name }
    MAIL { Faker::Internet.email }
    initialize_with { attributes.stringify_keys }
  end
end
