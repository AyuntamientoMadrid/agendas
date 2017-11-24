module Admin
  module OrganizationsHelper

    def total_organizations
      Organization.count
    end

    def form_new_organization?
      params[:action] == "new"
    end

  end
end
