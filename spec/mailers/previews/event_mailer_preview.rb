# Preview all emails at http://localhost:3000/rails/mailers/event_mailer
class EventMailerPreview < ActionMailer::Preview

  def cancel
    event = Event.second
    EventMailer.cancel(event)
  end

end
