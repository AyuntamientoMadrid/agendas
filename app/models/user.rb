class User < ActiveRecord::Base

  # Relations
  has_many :events
  has_many :manages, dependent: :destroy
  has_many :holders, through: :manages

  accepts_nested_attributes_for :manages, reject_if: :all_blank, allow_destroy: true


  # Validations
  validates_presence_of :first_name, :last_name, :email

  enum role: [:user, :admin]
  after_initialize :set_default_role, if: :new_record?
  after_initialize :set_active, if: :new_record?


  scope :active, -> {where(:active => true)}

  def name
    last_name.to_s + ", " + first_name.to_s
  end

  def full_name
    self.first_name+' '+self.last_name
  end

  def full_name_comma
    self.last_name.to_s+', '+self.first_name.to_s
  end

  def import
    kk = UwebApi.new
    pp = kk.client.call(:get_users_application_list, message: kk.request(Rails.application.secrets.uweb_api_user_key)).body
    tt = pp[:get_users_application_list_response][:get_users_application_list_return]
    Hash.from_xml(tt)['USUARIOS']['USUARIO'].each do |mc|
      yy = Hash.from_xml(kk.client.call(:get_user_data, message: kk.request(mc['CLAVE_IND'])).body[:get_user_data_response][:get_user_data_return])['USUARIO']
      user = User.find_by(user_key: yy['CLAVE_IND'])
      if user
        user.update(first_name: yy["NOMBRE_USUARIO"],last_name: yy["APELLIDO1_USUARIO"]+' '+yy["APELLIDO2_USUARIO"],email: yy["MAIL"],user_key: yy['CLAVE_IND'])
      else
        #create
        user = User.new(first_name: yy["NOMBRE_USUARIO"],last_name: yy["APELLIDO1_USUARIO"]+' '+yy["APELLIDO2_USUARIO"],email: yy["MAIL"],user_key: yy['CLAVE_IND'])
        user.password = SecureRandom.uuid
        user.save
      end
    end
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  private

  def set_active
    self.active ||= true
  end

  def set_default_role
    self.role ||= :user
  end

end
