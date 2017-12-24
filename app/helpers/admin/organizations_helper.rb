module Admin
  module OrganizationsHelper
    def form_new_organization?
      params[:controller] == "admin/organizations" &&
        (params[:action] == "new" || params[:action] == "create")
    end

    def category_name(id)
      Category.find(id).name
    end

    def show_partial?(partial)
      params[:show] ? params[:show] == partial && current_user.lobby? : false
    end
  end
end
