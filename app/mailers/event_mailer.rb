class EventMailer < ApplicationMailer

  def cancel_by_lobby(event)
    manages_emails = event.position.holder.users.collect(&:email).join(",")
    # pending titular email
    @to = manages_emails
    @lobby_name = event.lobby_user_name.present? ? event.lobby_user_name : event.organization.user.first_name
    @reasons = event.declined_reasons
    @name = event.user.full_name
    @event_title = event.title
    @event_location = event.location
    @event_scheduled = l event.scheduled, format: :long if event.scheduled
    @event_description = event.description
    @canceled_at = l event.canceled_at, format: :short if event.canceled_at
    @event_reference = event.id
    subject = t('mailers.cancel_event.subject', event_reference: @event_reference)
    mail(to: @to, bcc: "registrodelobbies@madrid.es", subject: subject)
  end

  def accept(event)
    @lobby_name = event.lobby_user_name.present? ? event.lobby_user_name : event.organization.user.first_name
    @event_title = event.title
    @event_description = event.description
    @event_reference = event.id
    @event_location = event.location
    @name = event.user.full_name
    @accepted_at = l event.accepted_at, format: :long if event.accepted_at
    @to = event.lobby_contact_email.present? ? event.lobby_contact_email : event.organization.user.email
    subject = t('mailers.accept_event.subject', event_reference: @event_reference)
    mail(to: @to, bcc: "registrodelobbies@madrid.es", subject: subject)
  end

  def decline(event)
    manages_emails = event.position.holder.users.collect(&:email).join(",")
    lobby_email = event.lobby_contact_email.present? ? event.lobby_contact_email : event.organization.user.email
    @to = lobby_email + ", " + manages_emails
    @reasons = event.declined_reasons
    @declined_at = l event.declined_at, format: :short if event.declined_at
    @event_title = event.title
    @event_description = event.description
    @event_reference = event.id
    subject = t('mailers.decline_event.subject', event_reference: @event_reference)
    mail(to: @to, bcc: "registrodelobbies@madrid.es", subject: subject)
  end

  def create(event)
    if event.status == "requested"
      holder_want_emails = true # holder want to receive emails notification or just the manager
      manages_emails = event.position.holder.users.collect(&:email).join(",")
      # pending titular email
      @to = manages_emails
      name = event.lobby_user_name.present? ? event.lobby_user_name : event.organization.user.first_name
    else
      @to = event.lobby_contact_email.present? ? event.lobby_contact_email : event.organization.user.email
      name = event.user.name
    end
    @event_title = event.title
    @event_description = event.description
    @event_reference = event.id
    @event_scheduled = l event.scheduled, format: :long if event.scheduled
    @lobby_name = event.organization_name
    @name = name
    subject = t('mailers.create_event.subject', event_reference: @event_reference)
    mail(to: @to, bcc: "registrodelobbies@madrid.es", subject: subject)
  end

  def cancel_by_holder(event)(event)
    @lobby_name = event.lobby_user_name.present? ? event.lobby_user_name : event.organization.user.first_name
    @reasons = event.declined_reasons
    @name = event.user.full_name
    @event_title = event.title
    @event_location = event.location
    @event_scheduled = l event.scheduled, format: :long if event.scheduled
    @event_description = event.description
    @declined_at = l event.declined_at, format: :short if event.declined_at
    @to = event.lobby_contact_email.present? ? event.lobby_contact_email : event.organization.user.email
    subject = t('mailers.decline_event_by_holder.subject', event_reference: @event_reference)
    mail(to: @to, bcc: "registrodelobbies@madrid.es", subject: subject)
  end

end
