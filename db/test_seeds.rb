require 'database_cleaner'
DatabaseCleaner.clean_with :truncation

# Areas
main_area = Area.create(title: 'IAM', active: 1)
area = Area.create(title: 'IAM servicio de portales y contenidos', parent: main_area, active: 1)
sub_area = Area.create(title: 'IAM departamento de gestion de contenidos y documentos', parent: area, active: 1)

# Admin
admin_user = User.create(password: '12345678', email: 'admin@agendas.dev', first_name: 'Admin', last_name: 'Istrator', active: 1)
admin_user.admin!

# Users who do not manage holders, will create the first event
user_without_holders = User.create(password: '12345678', email: 'pepe@agendas.dev', first_name: 'Pepe', last_name: 'Perez', active: 1)
user_without_holders.user!

# Users who manage holders
user_with_holders = User.create(password: '12345678', email: 'catalina@agendas.dev', first_name: 'Catalina', last_name: 'Perez', active: 1)
user_with_holders.user!
user_with_holders2 = User.create(password: '12345678', email: 'angelita@agendas.dev', first_name: 'Angelita', last_name: 'Gomez', active: 1)
user_with_holders2.user!

# Holder
holder_several_positions = Holder.create(first_name: 'Pilar', last_name: 'Lopez')
holder_one_position = Holder.create(first_name: 'Teresa', last_name: 'Ruiz')
holder_one_position2 = Holder.create(first_name: 'Maria José', last_name: 'Hernández')
holder_orphan_position = Holder.create(first_name: 'Carmelina', last_name: 'Cabezas')

# Position
Position.create(title: 'Director/a', to: Time.zone.now - 1.month, area_id: sub_area.id, holder_id: holder_several_positions.id)
sub_director = Position.create(title: 'Subdirector/a', to: nil, area_id: sub_area.id, holder_id: holder_several_positions.id)
Position.create(title: 'Jefe/a de seccion', to: nil, area_id: sub_area.id, holder_id: holder_several_positions.id)
commerce_boss = Position.create(title: 'Jefe negociado', to: nil, area_id: sub_area.id, holder_id: holder_one_position.id)
proyect_boss = Position.create(title: 'Jefa de proyecto', to: nil, area_id: sub_area.id, holder_id: holder_one_position2.id)
secretary = Position.create(title: 'Secretaria', to: nil, area_id: sub_area.id, holder_id: holder_orphan_position.id)

# Event
open_government = Event.create(location: Faker::Address.street_address, title: 'Gobierno Abierto',
                               description: 'El Gobierno Abierto tiene como objetivo que la ciudadanía colabore en la creación y mejora'\
                               ' de servicios públicos y en el robustecimiento de la transparencia y la rendición de cuentas.',
                               scheduled: rand(0..1) == 1 ? Faker::Time.forward(60, :day) : Faker::Time.backward(100, :morning),
                               user: user_without_holders, position: sub_director)
registration_offices = Event.create(location: Faker::Address.street_address, title: 'Oficinas de registro',
                                    description: 'Las oficinas de registro son los lugares que utiliza el ciudadano para presentar las'\
                                    ' solicitudes, escritos y comunicaciones que van dirigidos a las Administraciones Públicas. Asimismo,'\
                                    ' es el lugar que utiliza la Administración para registrar los documentos que remite al ciudadano, a'\
                                    ' entidades privadas o a la propia Administración.',
                                    scheduled: rand(0..1) == 1 ? Faker::Time.forward(60, :day) : Faker::Time.backward(100, :morning),
                                    user: user_without_holders, position: commerce_boss)
online_registration = Event.create(location: Faker::Address.street_address, title: 'Registro Electrónico',
                                   description: 'El Registro Electrónico es un punto para la presentación de documentos para su'\
                                   ' tramitación con destino a cualquier órgano administrativo de la Administración General del Estado,'\
                                   ' Organismo público o Entidad vinculado o dependiente a éstos, de acuerdo a lo dispuesto en la Ley'\
                                   ' 39/2015 , de 1 de octubre, del Procedimiento Administrativo Común de las Administraciones Públicas. ',
                                   scheduled: rand(0..1) == 1 ? Faker::Time.forward(60, :day) : Faker::Time.backward(100, :morning),
                                   user: user_without_holders, position: proyect_boss)
political_transparency = Event.create(location: Faker::Address.street_address, title: 'Transparencia política',
                                      description: 'Transparencia política es la obligación de los gobiernos de dar cuenta a los'\
                                      'ciudadanos de todos sus actos, especialmente del uso del dinero público y prevenir así los casos de'\
                                      ' corrupción',
                                      scheduled: rand(0..1) == 1 ? Faker::Time.forward(60, :day) : Faker::Time.backward(100, :morning),
                                      user: user_without_holders, position: secretary)

# Participant
Participant.create(position_id: commerce_boss.id, event_id: political_transparency.id)
Participant.create(position_id: proyect_boss.id, event_id: political_transparency.id)
Participant.create(position_id: secretary.id, event_id: open_government.id)
Participant.create(position_id: secretary.id, event_id: online_registration.id)
Participant.create(position_id: secretary.id, event_id: registration_offices.id)

# Manage
Manage.create(holder_id: holder_one_position.id, user: user_with_holders)
Manage.create(holder_id: holder_several_positions.id, user: user_with_holders2)

# Attendees
Attendee.create(event: open_government, name: Faker::Name.name, position: Faker::Name.title, company: Faker::Company.name)
Attendee.create(event: online_registration, name: Faker::Name.name, position: Faker::Name.title, company: Faker::Company.name)
Attendee.create(event: registration_offices, name: Faker::Name.name, position: Faker::Name.title, company: Faker::Company.name)

# Attachments
Attachment.create(title: 'PDF Attachment', file: File.open('./spec/fixtures/dummy.pdf'), event: registration_offices)
Attachment.create(title: 'JPG Attachment', file: File.open('./spec/fixtures/dummy.jpg'), event: registration_offices)

# Categories
names = ['Consultoría profesional y despachos de abogados', 'Empresas', 'Asociaciones/Fundaciones',
         'Sindicatos y organizaciones profesionales', 'Organizaciones empresariales',
         'ONGs y plataformas sin personalidad jurídica',
         'Universidades y centros de investigación',
         'Corporaciones de Derecho Público (colegios profesionales, cámaras oficiales, etc.)',
         'Iglesia y otras confesiones', 'Otro tipo de sujetos']

names.each do |name|
  Category.create(name: name)
end
