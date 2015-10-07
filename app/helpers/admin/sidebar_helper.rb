module Admin::SidebarHelper

  def active_menu(model)
    'active'.html_safe if params[:controller] == model
  end

end
