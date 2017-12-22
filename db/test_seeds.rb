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

# Event :title, :position, :scheduled, :location, :lobby_activity, :published_at,
open_government = Event.create(location: Faker::Address.street_address, title: 'Gobierno Abierto',
                               description: 'El Gobierno Abierto tiene como objetivo que la ciudadanía colabore en la creación y mejora'\
                               ' de servicios públicos y en el robustecimiento de la transparencia y la rendición de cuentas.',
                               scheduled: rand(0..1) == 1 ? Faker::Time.forward(60, :day) : Faker::Time.backward(100, :morning),
                               user: User.first, position: Position.first, lobby_activity: false, published_at: Date.today)
registration_offices = Event.create(location: Faker::Address.street_address, title: 'Oficinas de registro',
                                    description: 'Las oficinas de registro son los lugares que utiliza el ciudadano para presentar las'\
                                    ' solicitudes, escritos y comunicaciones que van dirigidos a las Administraciones Públicas. Asimismo,'\
                                    ' es el lugar que utiliza la Administración para registrar los documentos que remite al ciudadano, a'\
                                    ' entidades privadas o a la propia Administración.',
                                    scheduled: rand(0..1) == 1 ? Faker::Time.forward(60, :day) : Faker::Time.backward(100, :morning),
                                    user: user_without_holders, position: commerce_boss, lobby_activity: false, published_at: Date.today)
online_registration = Event.create(location: Faker::Address.street_address, title: 'Registro Electrónico',
                                   description: 'El Registro Electrónico es un punto para la presentación de documentos para su'\
                                   ' tramitación con destino a cualquier órgano administrativo de la Administración General del Estado,'\
                                   ' Organismo público o Entidad vinculado o dependiente a éstos, de acuerdo a lo dispuesto en la Ley'\
                                   ' 39/2015 , de 1 de octubre, del Procedimiento Administrativo Común de las Administraciones Públicas. ',
                                   scheduled: rand(0..1) == 1 ? Faker::Time.forward(60, :day) : Faker::Time.backward(100, :morning),
                                   user: user_without_holders, position: proyect_boss, lobby_activity: false, published_at: Date.today)
political_transparency = Event.create(location: Faker::Address.street_address, title: 'Transparencia política',
                                      description: 'Transparencia política es la obligación de los gobiernos de dar cuenta a los'\
                                      'ciudadanos de todos sus actos, especialmente del uso del dinero público y prevenir así los casos de'\
                                      ' corrupción',
                                      scheduled: rand(0..1) == 1 ? Faker::Time.forward(60, :day) : Faker::Time.backward(100, :morning),
                                      user: user_without_holders, position: secretary, lobby_activity: false, published_at: Date.today)

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
Attachment.create(title: 'PDF Attachment', file: File.open('./spec/fixtures/dummy.pdf'), public: true, event: registration_offices)
Attachment.create(title: 'JPG Attachment', file: File.open('./spec/fixtures/dummy.jpg'), public: true, event: registration_offices)

#Interests
interest_1 = Interest.find_or_create_by(name:"Actividad económica y empresarial")
interest_2 = Interest.find_or_create_by(name:"Actividad normativa y de regulación")
interest_3 = Interest.find_or_create_by(name:"Administración de personal y recursos humanos")
interest_4 = Interest.find_or_create_by(name:"Administración electrónica")
interest_5 = Interest.find_or_create_by(name:"Administración económica, financiera y tributaria de la Ciudad")
interest_6 = Interest.find_or_create_by(name:"Atención a la ciudadanía")
interest_7 = Interest.find_or_create_by(name:"Comercio")
interest_8 = Interest.find_or_create_by(name:"Consumo")
interest_9 = Interest.find_or_create_by(name:"Cultura (bibliotecas, archivos, museos, patrimonio histórico artístico, etc.)")
interest_10 = Interest.find_or_create_by(name:"Deportes")
interest_11 = Interest.find_or_create_by(name:"Desarrollo tecnológico")
interest_12 = Interest.find_or_create_by(name:"Educación y Juventud")
interest_13 = Interest.find_or_create_by(name:"Emergencias y seguridad")
interest_14 = Interest.find_or_create_by(name:"Empleo")
interest_15 = Interest.find_or_create_by(name:"Medio Ambiente")
interest_16 = Interest.find_or_create_by(name:"Medios de comunicación")
interest_17 = Interest.find_or_create_by(name:"Movilidad, transporte y aparcamientos")
interest_18 = Interest.find_or_create_by(name:"Salud")
interest_19 = Interest.find_or_create_by(name:"Servicios sociales")
interest_20 = Interest.find_or_create_by(name:"Transparencia y participación ciudadana")
interest_21 = Interest.find_or_create_by(name:"Turismo")
interest_22 = Interest.find_or_create_by(name:"Urbanismo")
interest_23 = Interest.find_or_create_by(name:"Vivienda")

# Categories
names = ['Consultoría profesional y despachos de abogados', 'Empresas', 'Asociaciones/Fundaciones',
         'Sindicatos y organizaciones profesionales', 'Organizaciones empresariales',
         'ONGs y plataformas sin personalidad jurídica',
         'Universidades y centros de investigación',
         'Corporaciones de Derecho Público (colegios profesionales, cámaras oficiales, etc.)',
         'Iglesia y otras confesiones', 'Otro tipo de sujetos']

names.each do |name|
  Category.find_or_create_by(name: name, display: true)
end

#Category
category_1 = Category.first
category_2 = Category.second
category_3 = Category.third

# Organization
user_lobby_1 = User.create(password: '12345678', email: 'lobby@agendas.dev', first_name: 'Pepe', last_name: 'Perez', active: 1, role: 2)
organization_1 = Organization.create(name: Faker::Company.name, entity_type: :lobby, inscription_date: Date.current - 1.year, denied_public_data: false, denied_public_events: false, user: user_lobby_1, category: category_1, reference: 'W45Y')

user_lobby_2 = User.create(password: '12345678', email: 'lob_by@agendas.dev', first_name: 'Pepe', last_name: 'Perez', active: 1, role: 2)
organization_2 = Organization.create(name: Faker::Company.name, entity_type: :lobby, inscription_date: Date.current - 2.years, denied_public_data: false, denied_public_events: false, user: user_lobby_2, category: category_2)

user_lobby_3 = User.create(password: '12345678', email: Faker::Internet.email, first_name: 'Pepe', last_name: 'Perez', active: 1, role: 2)
organization_3 = Organization.create(name: Faker::Company.name, entity_type: :lobby, inscription_date: Date.yesterday, denied_public_data: false, denied_public_events: false, user: user_lobby_3, category: category_3)

user_lobby_4 = User.create(password: '12345678', email: Faker::Internet.email, first_name: 'Pepe', last_name: 'Perez', active: 1, role: 2)
organization_4 = Organization.create(name: Faker::Company.name, entity_type: :lobby, inscription_date: Date.yesterday, denied_public_data: false, denied_public_events: false, user: user_lobby_4, category: category_1)

user_lobby_5 = User.create(password: '12345678', email: Faker::Internet.email, first_name: 'Pepe', last_name: 'Perez', active: 1, role: 2)
organization_5 = Organization.create(name: Faker::Company.name, entity_type: :association, inscription_date: Date.yesterday, denied_public_data: false, denied_public_events: false, user: user_lobby_5, category: category_2)

user_lobby_6 = User.create(password: '12345678', email: Faker::Internet.email, first_name: 'Pepe', last_name: 'Perez', active: 1, role: 2)
organization_6 = Organization.create(name: Faker::Company.name, entity_type: :association, inscription_date: Date.yesterday, denied_public_data: false, denied_public_events: false, user: user_lobby_6, category: category_1)

user_lobby_7 = User.create(password: '12345678', email: Faker::Internet.email, first_name: 'Pepe', last_name: 'Perez', active: 1, role: 2)
organization_7 = Organization.create(name: Faker::Company.name, entity_type: :association, inscription_date: Date.yesterday, denied_public_data: false, denied_public_events: false, user: user_lobby_7, category: category_3)

user_lobby_8 = User.create(password: '12345678', email: Faker::Internet.email, first_name: 'Pepe', last_name: 'Perez', active: 1, role: 2)
organization_8 = Organization.create(name: Faker::Name.name, first_surname: Faker::Name.last_name, second_surname: Faker::Name.last_name, entity_type: :association, inscription_date: Date.yesterday, denied_public_data: false, denied_public_events: false, user: user_lobby_8, category: category_2)

user_lobby_9 = User.create(password: '12345678', email: Faker::Internet.email, first_name: 'Pepe', last_name: 'Perez', active: 1, role: 2)
organization_9 = Organization.create(name: Faker::Name.name, first_surname: Faker::Name.last_name, second_surname: Faker::Name.last_name, entity_type: :federation, inscription_date: Date.yesterday, denied_public_data: false, denied_public_events: false, user: user_lobby_9, category: category_3)

user_lobby_10 = User.create(password: '12345678', email: Faker::Internet.email, first_name: 'Pepe', last_name: 'Perez', active: 1, role: 2)
organization_10 = Organization.create(name: Faker::Name.name, first_surname: Faker::Name.last_name, second_surname: Faker::Name.last_name, entity_type: :federation, inscription_date: Date.yesterday, denied_public_data: false, denied_public_events: false, user: user_lobby_10, category: category_1)

user_lobby_11 = User.create(password: '12345678', email: Faker::Internet.email, first_name: 'Pepe', last_name: 'Perez', active: 1, role: 2)
organization_11 = Organization.create(name: Faker::Name.name, first_surname: Faker::Name.last_name, second_surname: Faker::Name.last_name, entity_type: :federation, inscription_date: Date.yesterday, denied_public_data: false, denied_public_events: false, user: user_lobby_11, category: category_2)

30.times do
  Organization.create(name: Faker::Name.name, first_surname: Faker::Name.last_name, second_surname: Faker::Name.last_name, entity_type: :lobby, inscription_date: Date.yesterday, denied_public_data: false, denied_public_events: false, user: user_lobby_11, category: category_2)
end

#Legal Representant
LegalRepresentant.create(identifier: "43138883z", name: "Name", first_surname: "Surname", email: "email@legal.com", organization: organization_1)

#Agents
Agent.create(identifier: "43138882z", name: "Name1", from: Date.yesterday, organization: organization_1)
Agent.create(identifier: "43138881z", name: "Name2", from: Date.yesterday, organization: organization_1)

#Represented Entities
RepresentedEntity.create(identifier: "43138880z", name: "Name3", from: Date.yesterday, fiscal_year: 2017, organization: organization_1, range_fund: :range_2)
RepresentedEntity.create(identifier: "43138879z", name: "Name4", from: Date.yesterday, fiscal_year: 2017, organization: organization_1, range_fund: :range_3)

#OrganizationInterest
OrganizationInterest.create(organization: organization_1, interest: interest_1)
OrganizationInterest.create(organization: organization_1, interest: interest_2)
OrganizationInterest.create(organization: organization_1, interest: interest_3)

RegisteredLobby.create(name: "no_record")
RegisteredLobby.create(name: "generalitat_catalunya")
RegisteredLobby.create(name: "cnmc")
RegisteredLobby.create(name: "europe_union")
RegisteredLobby.create(name: "others")
