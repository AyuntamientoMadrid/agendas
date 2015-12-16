class DirectoryApi < MadridApi

  def client
    @client = Savon.client(wsdl: Rails.application.secrets.directory_api_endpoint,encoding: 'ISO-8859-1')
  end

  def request(params)
    h=Hash.new
    h[:aplicacion] = Rails.application.secrets.directory_api_app_key
    params.each do |k,v|
      h[k] = v
    end
    h
  end

  def get_units(codOrganico)
    data = data(:buscar_dependencias, {codOrganico: codOrganico})
    Hash.from_xml(data)['UNIDADES_ORGANIZATIVAS']
  end

  def get_unit(idUnidad)
    data = data(:consulta_datos_dependencia, {i_id_unidad: idUnidad})
    Hash.from_xml(data)['UNIDAD_ORGANIZATIVA']
  end

  def create_tree (internal_id)
    unit = get_unit(internal_id)
    area = Area.find_by(internal_id: unit['ID_UNIDAD'])
    if !area
      area = Area.create(internal_id: internal_id, title: unit['DENOMINACION'])
      if area.internal_id == unit['ID_UNIDAD_PADRE']
        #no hacemos nada
        return
      else
        #sacamos el padre
        parent = get_unit(unit['ID_UNIDAD_PADRE'])
        #lo creamos
        parent_area = Area.find_by(internal_id: parent['ID_UNIDAD'])
        if !parent_area
          parent_area = Area.create(internal_id: parent['ID_UNIDAD'], title: parent['DENOMINACION'])
        end
        # le asignamos al hijo el id del padre
        area.parent = parent_area
        area.save
        create_tree(parent['ID_UNIDAD'])

      end
    end
  end

end
