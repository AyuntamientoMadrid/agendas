module MenuHelper
  def current_class(active_path)
    return 'active' if request.path == active_path
  end
end
