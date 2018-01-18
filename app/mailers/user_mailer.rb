class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: t('mailers.welcome_user.subject'))
  end

  def infringement_email(infringement_email, attachment = nil)
    @infringement_email = infringement_email
    @attachment = attachment
    admin_emails = User.admin.collect(&:email).join(",")
    attachments[File.basename(attachment.path)] = File.read(attachment.path) if attachment
    mail(to: "buzonlobby@madrid.es", bcc: admin_emails, subject: infringement_email.subject)
  end

end
