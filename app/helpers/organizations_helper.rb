module OrganizationsHelper
  def oganizations_index_subtitle
    t "organizations.subtitle.default" if params[:order].blank? || params[:order] == :created_at
  end
end
