class EventMailer < ApplicationMailer

  def cancel(event)
    user = event.user
    @reasons = event.reasons
    @canceled_at = l event.canceled_at, format: :short
    @event_title = event.title
    @name = user.full_name
    subject = t('mailers.cancel_event.subject', title: @event_title)
    mail(to: user.email, subject: subject)
  end

end
