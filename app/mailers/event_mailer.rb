class EventMailer < ApplicationMailer

  def decline(event)
    return if event.lobby_contact_email.blank?
    @lobby_name = event.lobby_user_name
    @reasons = event.declined_reasons
    @event_title = event.title
    @name = event.user.full_name
    @declined_at = l event.declined_at, format: :short
    to = event.lobby_contact_email
    subject = t('mailers.decline_event.subject', title: @event_title)
    mail(to: to, subject: subject)
  end

  def accept(event)
    return if event.lobby_contact_email.blank?
    @lobby_name = event.lobby_user_name
    @event_title = event.title
    @name = event.lobby_user_name
    @accepted_at = l event.accepted_at, format: :short
    to = event.lobby_contact_email
    subject = t('mailers.accept_event.subject', title: @event_title)
    mail(to: to, subject: subject)
  end

  def create(event)
    return if event.organization.user.email.blank?
    to = event.organization.user.email
    cc = event.position.holder.users.collect(&:email).join(",") unless event.position.nil?
    @event_title = event.title
    @name = event.lobby_user_name.present? ? event.lobby_user_name : event.organization.user.first_name
    subject = t('mailers.create_event.subject', title: @event_title)
    mail(to: to, cc: cc, subject: subject)
  end

  def cancel(event, current_user)
    if current_user.lobby?
      return if event.organization.user.email.blank?
      cc = event.position.holder.users.collect(&:email).join(",") unless event.position.nil?
      to = event.organization.user.email
    else
      return if event.lobby_contact_email.blank?
      to = event.lobby_contact_email
      cc = []
    end
    @reasons = event.canceled_reasons
    @canceled_at = l event.canceled_at, format: :short
    @event_title = event.title
    subject = t('mailers.cancel_event.subject', title: @event_title)
    mail(to: to, subject: subject, cc: cc)
  end

end
