class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: t('mailers.welcome_organization.subject'))
  end

end
