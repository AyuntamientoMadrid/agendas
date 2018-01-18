class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: t('mailers.welcome_user.subject'))
  end

  def infringement_email(email, attachment)
    @email = email
    @infringement_reference = @email.id
    admin_emails = User.admin.collect(&:email).join(",")
    attachments[attachment.original_filename] = File.read(attachment.path) if attachment
    @link = email.link
    mail(to: "buzonlobby@madrid.es", bcc: admin_emails, subject: @email.subject)
  end

end
