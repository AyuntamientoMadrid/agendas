module OrganizationsHelper
  def oganizations_index_subtitle
    t "organizations.subtitle.default" if params[:order].blank? || params[:order] == :created_at
  end

  def organization_represented_entities_url_pattern(format)
    rooturl = root_url
    url = organization_represented_entities_url(organization_id: 1, format: format)
    "#{rooturl}#{url.gsub(rooturl, "").gsub("1", "organization_id")}"
  end

  def organization_agents_url_pattern(format)
    rooturl = root_url
    url = organization_agents_url(organization_id: 1, format: format)
    "#{rooturl}#{url.gsub(rooturl, "").gsub("1", "organization_id")}"
  end

  def organization_category_url_pattern
    rooturl = root_url
    url = organization_url(id: 1, format: :json)
    "#{rooturl}#{url.gsub(rooturl, "").gsub("1", "organization_id")}"
  end

  def organization_status
    canceled_true = @organization.canceled_at

    if canceled_true.present?
      '<span class="label alert">Baja </span>'.html_safe
    elsif  @organization.invalidate.present?
      '<span class="label warning">inhabilitado</span>'.html_safe
    else
      '<span class="label success">Activo</span>'.html_safe
    end
  end
end
