namespace :organizations do
  task :add_organization_categories => :environment do
    names = ['Consultoría profesional y despachos de abogados', 'Empresas', 'Asociaciones/Fundaciones',
             'Sindicatos y organizaciones profesionales', 'Organizaciones empresariales',
             'ONGs y plataformas sin personalidad jurídica',
             'Universidades y centros de investigación',
             'Corporaciones de Derecho Público (colegios profesionales, cámaras oficiales, etc.)',
             'Iglesia y otras confesiones', 'Otro tipo de sujetos']

    names.each do |name|
      Category.find_or_create_by(name: name)
    end

  end
end
