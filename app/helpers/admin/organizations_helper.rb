module Admin
  module OrganizationsHelper
    def form_new_organization?
      params[:controller] == "admin/organizations" &&
        (params[:action] == "new" || params[:action] == "create")
    end
  end
end
