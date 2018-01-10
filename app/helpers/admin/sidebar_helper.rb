module Admin::SidebarHelper

  def active_menu(model, action=nil, shortcut = nil)
    if active?(model, shortcut, action)
      return 'active'.html_safe
    end
  end

  def event_fixed_filters
    { tray: { utf8: "✓", search_title: "", search_person: "",
              status: ["requested", "declined"], lobby_activity: "1",
              controller: "events", action: "index"} ,
      events: { utf8: "✓", search_title: "", search_person: "",
                status: ["accepted", "done", "canceled"],
                controller: "events", action: "index"} }
  end

  def help_by_role(user)
    if user.lobby?
      "https://transparencia.madrid.es/FWProjects/transparencia/RelacionCiudadania/RegistroLobbies/Ficheros/ayuda_usuario_lobby.pdf"
    elsif user.user?
      "http://ayre.munimadrid.es/UnidadesDescentralizadas/GobiernoAbierto/Intranet/PublicidadActiva/Agendas/Ficheros/ayuda_usuario_gestor_agendas.pdf"
    else
      "http://ayre.munimadrid.es/UnidadesDescentralizadas/GobiernoAbierto/Intranet/PublicidadActiva/Agendas/Ficheros/ayuda_usuario_administrador_lobbies_agendas.pdf"
    end
  end

  private

    def current_action?(action)
      action.nil? || (params[:action] == action || params[:show] == action)
    end

    def event_filters?(shortcut)
      event_fixed_filters[shortcut] == request.env['action_dispatch.request.parameters'].symbolize_keys
    end

    def unfiltered?
      !(event_fixed_filters.values.include? request.env['action_dispatch.request.parameters'].symbolize_keys)
    end

    def active?(model, shortcut, action)
      # common comprobation for active link excluding events controller
      (params[:controller] == model && current_action?(action) && shortcut.nil? && unfiltered? ) ||
      # activaction for the two event lionks
        event_filters?(shortcut) ||
      # edit, and new avent activate :tray link
        (params[:controller] == model && current_action?(action) && shortcut == :tray && unfiltered? )
    end

end
