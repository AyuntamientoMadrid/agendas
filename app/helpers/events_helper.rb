module EventsHelper

  def cancelable_event?(event)
    !event.canceled? && event.status == 'accepted'
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

end
