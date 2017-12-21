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

  def decline(event)
    @lobby_name = event.lobby_user_name
    @reasons = event.declined_reasons
    @event_title = event.title
    @name = event.user.full_name
    @declined_at = l event.declined_at, format: :short
    subject = t('mailers.decline_event.subject', title: @event_title)
    mail(to: event.lobby_contact_email, subject: subject)
  end

  def accept(event)
    @lobby_name = event.lobby_user_name
    @reasons = event.accepted_reasons
    @event_title = event.title
    @name = event.user.full_name
    @accepted_at = l event.accepted_at, format: :short
    subject = t('mailers.accept_event.subject', title: @event_title)
    mail(to: event.lobby_contact_email, subject: subject)
  end

end
