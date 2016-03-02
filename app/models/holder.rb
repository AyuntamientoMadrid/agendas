class Holder < ActiveRecord::Base

  # Relations
  has_many :manages
  has_many :users, through: :manages

  has_many :positions, dependent: :delete_all

  accepts_nested_attributes_for :positions, reject_if: :all_blank, allow_destroy: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  #validate :must_have_position

  def must_have_position
    if positions.empty? or positions.all? {|child| child.marked_for_destruction? }
      errors.add(:base, I18n.translate('backend.must_have_position'))
    end
  end

  def full_name
    (self.first_name.to_s+' '+self.last_name.to_s).mb_chars.titleize.to_s
  end

  def full_name_comma
    (self.last_name.to_s+', '+self.first_name.to_s).mb_chars.titleize.to_s
  end

  def current_position
    self.positions.current.first
  end

  def self.create_from_uweb(data)
    holder = Holder.find_or_initialize_by(user_key: data['CLAVE_IND'])
    holder.first_name = data["NOMBRE_USUARIO"]
    holder.last_name = data["APELLIDO1_USUARIO"]+' '+data["APELLIDO2_USUARIO"]
    holder
  end
end
