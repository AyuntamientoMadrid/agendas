# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # http://localhost:3000/rails/mailers/user_mailer/welcome
  def welcome
    user = User.find(3)
    UserMailer.welcome(user)
  end

  # http://localhost:3000/rails/mailers/user_mailer/infringement_email
  def infringement_email
    infringement_email = InfringementEmail.new(subject: "Infringement subject",
                                               description: "Infringement description",
                                               link: "http://www.link.com",
                                               affected: "What",
                                               affected_referer: "Referer")
    UserMailer.infringement_email(infringement_email)
  end
end
