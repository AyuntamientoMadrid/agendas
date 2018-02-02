class ResponsibleStatementMailer < ApplicationMailer

  def notification_error(organization)
    @organization = organization
    subject = t('mailers.notification_error.subject', lobby_name: organization.fullname)
    mail(to: "registrodelobbies@madrid.es", subject: subject)
  end

  def notification_success(organization)
    @organization = organization
    subject = t("mailers.notification_success.subject", lobby_name: organization.fullname)
    mail(to: "registrodelobbies@madrid.es", subject: subject)
  end

end
