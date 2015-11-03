class Holder < ActiveRecord::Base

  # Relations
  has_many :manages
  has_many :users, through: :manages

  has_many :positions, dependent: :delete_all

  accepts_nested_attributes_for :positions, reject_if: :all_blank, allow_destroy: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validate :must_have_position

  def must_have_position
    if positions.empty? or positions.all? {|child| child.marked_for_destruction? }
      errors.add(:base, I18n.translate('backend.must_have_position'))
    end
  end

  def full_name
    self.first_name.to_s+' '+self.last_name.to_s
  end

  def full_name_comma
    self.last_name.to_s+', '+self.first_name.to_s
  end

  def current_position
    self.positions.current.first
  end

  def self.import(profileKey)
    api = UwebApi.new
    response = api.client.call(:get_users_profile_application_list, message: api.request({profileKey: profileKey})).body
    data = response[:get_users_profile_application_list_response][:get_users_profile_application_list_return]
    Hash.from_xml(data)['USUARIOS']['USUARIO'].each do |mc|
      create_from_uweb(Hash.from_xml(api.client.call(:get_user_data, message: api.request({userKey: mc['CLAVE_IND']})).body[:get_user_data_response][:get_user_data_return])['USUARIO'])
    end
  end

  def self.create_from_uweb(data)
    p data
    user = Holder.find_or_initialize_by(user_key: data['CLAVE_IND'])
    user.first_name = data["NOMBRE_USUARIO"]
    user.last_name = data["APELLIDO1_USUARIO"]+' '+data["APELLIDO2_USUARIO"]
    p user

    api = DirectoryApi.new
    response = api.client.call(:buscar_dependencias, message: api.request({cod_organico: data['COD_UNIDAD']})).body
    pata = response[:buscar_dependencias_response][:buscar_dependencias_return]
    p pata


    if user.save
      p 'mc'
    else
      p user.errors
    end
  end
end
