class EventMailer < ApplicationMailer

  def decline(event)
    return unless event.lobby_contact_email
    @lobby_name = event.lobby_user_name
    @reasons = event.declined_reasons
    @event_title = event.title
    @name = event.user.full_name
    @declined_at = l event.declined_at, format: :short
    subject = t('mailers.decline_event.subject', title: @event_title)
    mail(to: event.lobby_contact_email, subject: subject)
  end

  def accept(event)
    return unless event.lobby_contact_email
    @lobby_name = event.lobby_user_name
    @event_title = event.title
    @name = event.user.full_name
    @accepted_at = l event.accepted_at, format: :short
    subject = t('mailers.accept_event.subject', title: @event_title)
    mail(to: event.lobby_contact_email, subject: subject)
  end

  def cancel(event, user)
    if user.lobby?
      to = user.email
      return unless  user.email
      name = event.lobby_user_name
    else
      return unless event.lobby_contact_email
      to = event.lobby_contact_email
      name = event.user.name
    end
    @reasons = event.canceled_reasons
    @canceled_at = l event.canceled_at, format: :short
    @event_title = event.title
    @name = name
    subject = t('mailers.cancel_event.subject', title: @event_title)
    mail(to: to, subject: subject)
  end

  def create(event, user)
    if user.lobby?
      to = user.email
      return unless  user.email
      name = event.lobby_user_name
    else
      return unless event.lobby_contact_email
      to = event.lobby_contact_email
      name = event.user.name
    end
    @lobby_name = event.lobby_user_name
    @event_title = event.title
    @name = name
    subject = t('mailers.create_event.subject', title: @event_title)
    mail(to: to, subject: subject)
  end

end
