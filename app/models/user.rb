class User < ActiveRecord::Base

  # Relations
  has_many :events
  has_many :manages, dependent: :destroy
  has_many :holders, through: :manages

  # Validations
  validates_presence_of :first_name, :last_name, :email

  enum role: [:user, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def name
    last_name.to_s + ", " + first_name.to_s
  end

  def set_default_role
    self.role ||= :user
  end

  def full_name
    self.first_name+' '+self.last_name
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
