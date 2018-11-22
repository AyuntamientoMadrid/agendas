module MailerHelper

  def newsletter?
    action_name == "newsletter"
  end

end
