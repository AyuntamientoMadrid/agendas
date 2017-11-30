class UserMailer < ApplicationMailer

  def infringement_email(email, attachment)
    @email = email
    admin_emails = User.admin.collect(&:email).join(",")
    attachments[attachment.original_filename] = File.read(attachment.path)

    mail(bcc: admin_emails, subject: @email.subject)
  end
end
