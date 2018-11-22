class Newsletter < ActiveRecord::Base
  belongs_to :interest

  validates :subject, presence: true
  validates :body, presence: true
  validates :interest_id, presence: true

  def list_of_recipient_emails
    Organization.where(organization_interests: { interest: interest })
    .joins(:organization_interests)
    .pluck(:email) << admin_email
  end

  def admin_email
    "registrodelobbies@madrid.es"
  end

  def draft?
    sent_at.nil?
  end

  def deliver
    list_of_recipient_emails.each do |recipient_email|
      if valid_email?(recipient_email)
        begin
          UserMailer.newsletter(self, recipient_email).deliver_now
          log_delivery(recipient_email)
        rescue
          log_delivery(recipient_email, :email_error)
        end
      end
    end
  end

  private

    def valid_email?(email)
      email.match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i)
    end

    def log_delivery(recipient_email, action=:email)
      if recipient_email == admin_email
        Log.activity(nil, "admin_email", self)
      else
        organization = Organization.where(email: recipient_email).first
        Log.activity(organization, action, self)
      end
    end
end
