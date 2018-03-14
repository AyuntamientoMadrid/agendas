# Preview all emails at http://localhost:3000/rails/mailers/responsible_statement_mailer
class ResponsibleStatementMailerPreview < ActionMailer::Preview

  # http://localhost:3000/rails/mailers/responsible_statement_mailer/notification_error
  def notification_error
    organization = Organization.last
    organization.errors.add(:base, "Ya existe una organización como lobby con este CIF")
    # organization.save
    ResponsibleStatementMailer.notification_error(organization)
  end

  # http://localhost:3000/rails/mailers/responsible_statement_mailer/notification_success
  def notification_success
    organization = Organization.last
    ResponsibleStatementMailer.notification_success(organization)
  end
end
