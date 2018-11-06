class Log < ActiveRecord::Base
  belongs_to :actionable, polymorphic: true
  belongs_to :organization

  def self.activity(organization, action, actionable)
    create(organization: organization, action: action.to_s, actionable: actionable)
  end

end
