module EventsHelper

  def cancelable_event?(event)
    !event.canceled?
  end

  def declinable_or_aceptable_event?(event)
    !event.canceled? && !event.declined? && !event.accepted?
  end

  def event_title(current_user)
    if current_user.lobby?
      t("backend.title_event_lobby")
    else
      t("backend.title_event")
    end
  end

  def event_new(current_user)
    if current_user.lobby?
      t("backend.new_requeseted_event")
    else
      t("backend.new_event")
    end
  end

  def event_description(current_user)
    if current_user.lobby?
      t("backend.description_lobby")
    elsif current_user.user?
      t('backend.description_manager')
    else
      t('backend.description')
    end
  end

  def reason_text(event)
    if event.declined_reasons.present?
      event.declined_reasons.html_safe
    else
      event.canceled_reasons.html_safe
    end
  end

end
