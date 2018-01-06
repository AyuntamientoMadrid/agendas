namespace :organizations do

  desc "Add new categories to database if they do not exists"
  task :add_categories => :environment do
    names = ['Consultoría profesional y despachos de abogados', 'Empresas', 'Asociaciones', 'Fundaciones',
             'Sindicatos y organizaciones profesionales', 'Organizaciones empresariales',
             'ONGs y plataformas sin personalidad jurídica',
             'Universidades y centros de investigación',
             'Corporaciones de Derecho Público (colegios profesionales, cámaras oficiales, etc.)',
             'Iglesia y otras confesiones', 'Otro tipo de sujetos']

    names.each do |name|
      Category.find_or_create_by(name: name, display: true)
    end
  end

  desc "Add new interests to database if they do not exists"
  task :add_interests => :environment do
    interests = ['Actividad económica y empresarial',
                 'Distritos',
                 'Administración de personal y recursos humanos',
                 'Administración electrónica',
                 'Administración económica, financiera y tributaria de la Ciudad',
                 'Atención a la ciudadanía',
                 'Comercio',
                 'Consumo',
                 'Cultura (bibliotecas, archivos, museos, patrimonio histórico artístico, etc.)',
                 'Deportes',
                 'Desarrollo tecnológico',
                 'Educación y Juventud',
                 'Emergencias y seguridad',
                 'Empleo',
                 'Medio Ambiente',
                 'Medios de comunicación',
                 'Movilidad, transporte y aparcamientos',
                 'Salud',
                 'Servicios sociales',
                 'Transparencia y participación ciudadana',
                 'Turismo',
                 'Urbanismo',
                 'Vivienda']

    interests.each do |name|
      Interest.find_or_create_by(name: name)
    end
  end

  desc "Add new registered_lobbies to database if they do not exists"
  task :add_registered_lobbies => :environment do
    registered_lobbies = ['no_record',
                          'generalitat_catalunya',
                          'cnmc',
                          'europe_union',
                          'others']


    registered_lobbies.each do |name|
      RegisteredLobby.find_or_create_by(name: name)
    end
  end

  desc "Update registered_lobbies names"
  task :update_registered_lobbies_names => :environment do
    registered_lobbies = ['no_record',
                          'generalitat_catalunya',
                          'cnmc',
                          'europe_union',
                          'others']

    real_names         = ['Ninguno',
                          'Generalidad catalunya',
                          'CNMC',
                          'Unión Europea',
                          'Otro']

    registered_lobbies.each_with_index do |name, index|
      registered_lobby = RegisteredLobby.find_by(name: name)
      registered_lobby.update(name: real_names[index]) if registered_lobby.present?
    end
  end

end
