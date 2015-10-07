class User < ActiveRecord::Base

  # Relations
  has_many :events
  has_many :manages, dependent: :destroy
  has_many :holders, through: :manages

  accepts_nested_attributes_for :manages, reject_if: :all_blank, allow_destroy: true


  # Validations
  validates_presence_of :first_name, :last_name, :email

  enum role: [:user, :admin]
  after_initialize :set_default_role, :if => :new_record?


  scope :active, -> {where(:active => true)}

  def name
    last_name.to_s + ", " + first_name.to_s
  end

  def set_default_role
    self.role ||= :user
  end

  def full_name
    self.first_name+' '+self.last_name
  end

  def full_name_comma
    self.last_name.to_s+', '+self.first_name.to_s
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
end
