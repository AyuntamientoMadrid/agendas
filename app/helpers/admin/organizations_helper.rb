module Admin
  module OrganizationsHelper
    def total_organizations
      Organization.count
    end

    def form_new_organization?
      params[:controller] == "admin/organizations" &&
        (params[:action] == "new" || params[:action] == "create")
    end
  end
end
