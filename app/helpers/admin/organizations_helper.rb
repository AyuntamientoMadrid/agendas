module Admin::OrganizationsHelper

  def total_organizations
    Organization.count
  end

end
