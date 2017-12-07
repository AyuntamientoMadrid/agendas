module Admin::SidebarHelper

  def active_menu(model, action=nil)
    'active'.html_safe if params[:controller] == model && current_action?(action)
  end

  private

    def current_action?(action)
      action.nil? || (params[:action] == action || params[:show] == action)
    end

end
