class Newsletter < ActiveRecord::Base

  validates :subject, presence: true
  validates :body, presence: true

  def list_of_recipient_emails
    User.admin.pluck(:email)
  end

  def draft?
    sent_at.nil?
  end

  def deliver
    list_of_recipient_emails.each do |recipient_email|
      if valid_email?(recipient_email)
        UserMailer.newsletter(self, recipient_email).deliver_now
      end
    end
  end

  private

    def valid_email?(email)
      email.match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i)
    end

end
