module Admin::AreasHelper

  def parent_label(area)
    'data-tt-parent-id='+area.parent.id.to_s+''.html_safe if area.parent.present?
  end

  def nested_areas(areas)
    areas.map do |area|
      render(area) + nested_areas(area.children.order(:title))
    end.join.html_safe unless areas.blank?
  end

end
