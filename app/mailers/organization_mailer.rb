class OrganizationMailer < ApplicationMailer

  def create(organization)
    @name = organization.user_name
    @title = organization.fullname

    subject = t('mailers.create_organization.subject', title: @title)
    mail(to: organization.user.email, subject: subject, cco: 'registrodelobbies@madrid.es')
  end

  def invalidate(organization)
    @name = organization.user_name
    @title = organization.fullname

    subject = t('mailers.invalidate_organization.subject', title: @title)
    mail(to: organization.user.email, subject: subject, cco: 'registrodelobbies@madrid.es')
  end

  def delete(organization)
    @name = organization.user_name
    @title = organization.fullname

    subject = t('mailers.delete_organization.subject', title: @title)
    mail(to: organization.user.email, subject: subject, cco: 'registrodelobbies@madrid.es')
  end

  def update(organization)
    @name = organization.user_name
    @title = organization.fullname

    subject = t('mailers.update_organization.subject', title: @title)
    mail(to: organization.user.email, subject: subject, cco: 'registrodelobbies@madrid.es')
  end

end
