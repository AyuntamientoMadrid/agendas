class Organization < ActiveRecord::Base
  attr_accessor :invalidate, :validate

  enum range_fund: [:range_1, :range_2, :range_3, :range_4]
  enum entity_type: { association: 0, federation: 1, lobby: 2 }
  validates :inscription_reference, uniqueness: true, allow_blank: true, allow_nil: true
  validates :name, :category_id, presence: true
  validates :invalidated_reasons, presence: { message: I18n.t('event.cancel_reasons_needed') }, if: Proc.new { |a| a.invalidated_at }

  has_many :represented_entities, dependent: :destroy, inverse_of: :organization
  has_many :agents, dependent: :destroy
  has_many :organization_interests, dependent: :destroy
  has_many :interests, through: :organization_interests, dependent: :destroy
  has_many :events
  has_many :organization_registered_lobbies, dependent: :destroy
  has_many :registered_lobbies, through: :organization_registered_lobbies, dependent: :destroy
  has_many :attachments, dependent: :destroy
  has_one :user, dependent: :destroy
  has_one :legal_representant, dependent: :destroy
  belongs_to :category

  accepts_nested_attributes_for :legal_representant, update_only: true, allow_destroy: true
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :represented_entities, allow_destroy: true
  accepts_nested_attributes_for :registered_lobbies, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank

  before_validation :invalidate_organization, :validate_organization
  after_create :set_inscription_date
  before_destroy :send_delete_mail

  searchable do
    text :name, :first_surname, :second_surname, :description
    integer :entity_type_id
    time :canceled_at
    time :created_at
    time :invalidated_at
    boolean :invalidate do
      !invalidated_at.nil?
    end
    integer :interest_ids, multiple: true do
      interests.map(&:id)
    end
    integer :category_id
    integer :id
    join(:lobby_activity, :target => Event, :type => :boolean, :join => { :from => :organization_id, :to => :id })
    join(:name, :prefix => "agent", :target => Agent, :type => :text, :join => { :from => :organization_id, :to => :id })
    join(:first_surname, :prefix => "agent", :target => Agent, :type => :text, :join => { :from => :organization_id, :to => :id })
    join(:second_surname, :prefix => "agent", :target => Agent, :type => :text, :join => { :from => :organization_id, :to => :id })
    time :inscription_date
    string :name
  end

  scope :invalidated, -> { where('invalidated_at is not null') }
  scope :validated, -> { where('invalidated_at is null') }
  scope :lobbies, -> { where('entity_type = ?', 2) }
  scope :full_like, ->(name) { where("identifier ilike ? OR name ilike ?", name, name) }

  # def send_create_mail
  #   OrganizationMailer.create(self).deliver_now
  # end

  def send_delete_mail
    OrganizationMailer.delete(self).deliver_now
  end

  def send_invalidate_mail
    OrganizationMailer.invalidate(self).deliver_now
  end

  def send_update_mail
    OrganizationMailer.update(self).deliver_now
  end

  def entity_type_id
    Organization.entity_types[entity_type]
  end

  def invalidate_organization
    return unless invalidate == 'true' && invalidated_at.nil?
    self.invalidated_at = Time.zone.today
  end

  def validate_organization
    return unless validate == 'true' && !invalidated_at.nil?
    self.invalidated_at = nil
    self.invalidated_reasons = nil
  end

  def fullname
    str = name
    str += " #{first_surname}"  if first_surname.present?
    str += " #{second_surname}" if second_surname.present?
    str
  end

  def legal_representant_full_name
    legal_representant.fullname if legal_representant
  end

  def user_name
    user.full_name if user
  end

  def set_inscription_date
    self.inscription_date = Date.current if inscription_date.blank?
    save
  end

  def set_invalidate
    self.invalidate = false
    save
    send_invalidate_mail
  end

  def interest?(id)
    interests.pluck(:id).include?(id)
  end

  def invalidated?
    invalidated_at.present?
  end

  def canceled?
    !canceled_at.nil?
  end

end
