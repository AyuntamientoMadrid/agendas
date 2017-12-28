class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :events_home_path

  def change_language
    I18n.locale = params[:lang]
    redirect_to request.referer
  end

  def events_home_path(user)
    if user.user?
      events_path({ utf8: "✓", search_title: "", search_person: "",
                               status: ["requested", "declined"], lobby_activity: "1",
                               controller: "events", action: "index" })
    else
      events_path
    end
  end

end
