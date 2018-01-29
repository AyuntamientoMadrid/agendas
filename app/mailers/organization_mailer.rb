class OrganizationMailer < ApplicationMailer

  def welcome(organization)
    @organization = organization

    # TODO: Uncommet, remove or refactor on feature/bareg-inegration
    # when organization is created through integration we should generate ramdom password
    # if organization.user.password.blank?
    #   random_password = Devise.friendly_token.first(8)
    #   organization.user.password = random_password
    #   organization.user.password_confirmation = random_password
    #   organization.save
    # end

    subject = t('mailers.create_organization.subject', lobby_name: organization.fullname)
    to = organization.user.nil? ? [] : organization.user.email
    mail(to: to, subject: subject, bcc: 'registrodelobbies@madrid.es')
  end

  def delete(organization)
    @organization = organization

    subject = t('mailers.delete_organization.subject', lobby_name: organization.fullname)
    to = organization.user.nil? ? [] : organization.user.email
    mail(to: to, subject: subject, bcc: 'registrodelobbies@madrid.es')
  end

  def invalidate(organization)
    @organization = organization

    subject = t('mailers.invalidate_organization.head1', lobby_name: organization.fullname)
    to = organization.user.nil? ? [] : organization.user.email
    mail(to: to, subject: subject, bcc: 'registrodelobbies@madrid.es')
  end

  def update(organization)
    @organization = organization

    subject = t('mailers.update_organization.subject', lobby_name: organization.fullname)
    to = organization.user.nil? ? [] : organization.user.email
    mail(to: to, subject: subject, bcc: 'registrodelobbies@madrid.es')
  end

end
