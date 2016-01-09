FactoryGirl.define do
  factory :uweb_user, class:Array do
    skip_create
    CLAVE_IND '00001'
    NOMBRE_USUARIO 'First'
    APELLIDO1_USUARIO 'Last1'
    APELLIDO2_USUARIO 'Last2'
    MAIL 'first.last@example.com'

    initialize_with { attributes.stringify_keys }
  end
end
