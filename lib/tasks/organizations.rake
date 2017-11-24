namespace :organizations do
  task :add_organization_interests => :environment do
    interests = ['Actividad económica y empresarial',
                 'Actividad normativa y de regulación',
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
end
