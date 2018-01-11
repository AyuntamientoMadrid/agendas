class OrganizationMailer < ApplicationMailer

  def create(organization)
    @user_name = organization.user_name
    @title = organization.fullname
    @lobby_reference = organization.id
    @lobby_name = organization.name
    @lobby_inscription_date = organization.inscription_date
    @user_password = Devise.friendly_token.first(8)
    organization.change_password(@user_password)
    @link = "https://registrodelobbies.madrid.es"

    subject = t('mailers.create_organization.subject', lobby_reference: @lobby_reference)
    to = organization.user.nil? ? [] : organization.user.email
    mail(to: to, subject: subject, bcc: 'registrodelobbies@madrid.es')
  end

  def invalidate(organization)
    @lobby_reference = organization.id
    @lobby_name = organization.name
    @lobby_invalidated_at = l organization.invalidated_at, format: :long if organization.invalidated_at

    subject = t('mailers.invalidate_organization.subject', lobby_reference: @lobby_reference)
    to = organization.user.nil? ? [] : organization.user.email
    mail(to: to, subject: subject, bcc: 'registrodelobbies@madrid.es')
  end

  def delete(organization)
    @name = organization.user_name
    @title = organization.fullname

    subject = t('mailers.delete_organization.subject', title: @title)
    to = organization.user.nil? ? [] : organization.user.email
    mail(to: to, subject: subject, bcc: 'registrodelobbies@madrid.es')
  end

  def update(organization)
    @lobby_reference = organization.id
    @lobby_name = organization.name
    @lobby_updated_date = l organization.modification_date, format: :long if organization.modification_date

    subject = t('mailers.update_organization.subject', lobby_reference: @lobby_reference)
    to = organization.user.nil? ? [] : organization.user.email
    mail(to: to, subject: subject, bcc: 'registrodelobbies@madrid.es')
  end

end
