module MenuHelper
  def current_class(active_path)
    return 'active' if request.path == active_path
  end
  def admin_current_class
    return 'active' if request.path.include?("/admin") || request.path.include?("/events")
  end
end
