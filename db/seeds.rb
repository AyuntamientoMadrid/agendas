# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Interests
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
  Interest.create(name: name)
end
puts "Interests created ✅"

# Categories
names = ['Consultoría profesional y despachos de abogados', 'Empresas', 'Asociaciones/Fundaciones',
         'Sindicatos y organizaciones profesionales', 'Organizaciones empresariales',
         'ONGs y plataformas sin personalidad jurídica',
         'Universidades y centros de investigación',
         'Corporaciones de Derecho Público (colegios profesionales, cámaras oficiales, etc.)',
         'Iglesia y otras confesiones', 'Otro tipo de sujetos']

names.each do |name|
  Category.find_or_create_by(name: name)
end
puts "Categories created ✅"
