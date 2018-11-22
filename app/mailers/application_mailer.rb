class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@madrid.es"
  layout 'mailer'
  add_template_helper(MailerHelper)
end
