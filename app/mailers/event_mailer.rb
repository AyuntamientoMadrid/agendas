class EventMailer < ApplicationMailer

  def decline(event)
    @lobby_name = event.lobby_user_name.present? ? event.lobby_user_name : event.organization.user.first_name
    @reasons = event.declined_reasons
    @event_title = event.title
    @name = event.user.full_name
    @declined_at = l event.declined_at, format: :short
    to = event.lobby_contact_email.present? ? event.lobby_contact_email : event.organization.user.email
    subject = t('mailers.decline_event.subject', title: @event_title)
    mail(to: to, bcc: "registrodelobbies@madrid.es", subject: subject)
  end

  def accept(event)
    @lobby_name = event.lobby_user_name.present? ? event.lobby_user_name : event.organization.user.first_name
    @event_title = event.title
    @name = event.user.full_name
    @accepted_at = l event.accepted_at, format: :short
    to = event.lobby_contact_email.present? ? event.lobby_contact_email : event.organization.user.email
    subject = t('mailers.accept_event.subject', title: @event_title)
    mail(to: to, bcc: "registrodelobbies@madrid.es", subject: subject)
  end

  def cancel(event)
    #pending titular email
    #pending canceled author
    manages_emails = event.position.holder.users.collect(&:email).join(",")
    lobby_email = event.lobby_contact_email.present? ? event.lobby_contact_email : event.organization.user.email
    to = lobby_email + ", " + manages_emails
    @reasons = event.canceled_reasons
    @canceled_at = l event.canceled_at, format: :short
    @event_title = event.title
    subject = t('mailers.cancel_event.subject', title: @event_title)
    mail(to: to, bcc: "registrodelobbies@madrid.es", subject: subject)
  end

  def create(event)
    if event.status == "requested"
      manages_emails = event.position.holder.users.collect(&:email).join(",")
      #pending titular email
      to = manages_emails
      name = event.lobby_user_name.present? ? event.lobby_user_name : event.organization.user.first_name
    else
      to = event.lobby_contact_email.present? ? event.lobby_contact_email : event.organization.user.email
      name = event.user.name
    end
    @event_title = event.title
    @name = name
    subject = t('mailers.create_event.subject', title: @event_title)
    mail(to: to, bcc: "registrodelobbies@madrid.es", subject: subject)
  end

end
