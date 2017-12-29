class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :events_home_path

  def change_language
    I18n.locale = params[:lang]
    redirect_to request.referer
  end

  def events_home_path(user, redirect_requested_or_declined_events)
    if user.user?
      if redirect_requested_or_declined_events
        status = ["requested", "declined"]
        lobby_activity = "1"
      else
        status = ["accepted", "done", "canceled"]
        lobby_activity = nil
      end
      events_path({ utf8: "✓", search_title: "", search_person: "",
                               status: status, lobby_activity: lobby_activity,
                               controller: "events", action: "index" })
    else
      events_path
    end
  end

end
