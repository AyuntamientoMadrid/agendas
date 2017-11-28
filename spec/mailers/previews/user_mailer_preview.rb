# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def welcome
    user = User.find(3)
    UserMailer.welcome(user)
  end
end
