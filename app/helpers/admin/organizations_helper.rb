module Admin
  module OrganizationsHelper
    def total_organizations
      Organization.count
    end
  end
end
