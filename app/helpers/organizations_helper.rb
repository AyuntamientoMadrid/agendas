module OrganizationsHelper
  def organizations_index_subtitle
    if params[:order] == '1' || params[:order] == '2' || params[:order] == '3'
      t "organizations.results_title"
    else
      t "organizations.subtitle.default"
    end
  end

  def organization_represented_entities_url_pattern(format)
    rooturl = root_url
    url = organization_represented_entities_url(organization_id: 1, format: format)
    "#{rooturl}#{url.gsub(rooturl, '').gsub('1', 'organization_id')}"
  end

  def organization_agents_url_pattern(format)
    rooturl = root_url
    url = organization_agents_url(organization_id: 1, format: format)
    "#{rooturl}#{url.gsub(rooturl, '').gsub('1', 'organization_id')}"
  end

  def organization_category_url_pattern
    rooturl = root_url
    url = organization_url(id: 1, format: :json)
    "#{rooturl}#{url.gsub(rooturl, '').gsub('1', 'organization_id')}"
  end

  def search_by_filter?
    (params[:interests].present? || params[:category].present? || params[:keyword].present?)
  end

  def organization_status(organization)
    if organization.canceled?
      '<span class="label alert">Baja </span>'.html_safe
    elsif organization.invalidated?
      if current_user.present? && current_user.admin?
        '<span class="label warning">Inhabilitado</span>'.html_safe
      else
        '<span class="label alert">Baja </span>'.html_safe
      end
    else
      '<span class="label success">Activo</span>'.html_safe
    end
  end

  def events_as_lobby_by(organization)
    organization.events.where(lobby_activity: true, status: 2).count
  end

  def options_for_registered_lobby
    registered_lobbies = RegisteredLobby.all.select("id","name")
    result = {}
    registered_lobbies.map { |rl| result[t("backend.identifying_data.registered_lobbies.#{rl.name}")] = rl.id }
    result
  end

end
