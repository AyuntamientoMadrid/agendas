module OrganizationsHelper
  def oganizations_index_subtitle
    t "organizations.subtitle.default" if params[:order].blank? || params[:order] == :created_at
  end

  def organization_represented_entities_url_pattern(format = :html)
    rooturl = root_url
    url = admin_organization_represented_entities_url(organization_id: 1, format: format)
    "#{rooturl}#{url.gsub(rooturl, "").gsub("1", "organization_id")}"
  end

end
