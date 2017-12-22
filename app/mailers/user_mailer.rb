class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: t('mailers.welcome_organization.subject'))
  end

  def infringement_email(email, attachment)
    @email = email
    admin_emails = User.admin.collect(&:email).join(",")
    attachments[attachment.original_filename] = File.read(attachment.path) if attachment

    mail(bcc: admin_emails, subject: @email.subject)
  end

end
