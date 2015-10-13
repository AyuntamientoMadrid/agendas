module Admin::AreasHelper

  def tree_row(area)
    output = ''
    if area.children.empty?
      output += render 'areas/cell', area: area
    else
      area.children.each do |child|
        output += "/#{tree_row(child)}"
      end
    end
    output.html_safe
  end

  def parent_label(area)
    'data-tt-parent-id="'+area.parent.id.to_s+'"'.html_safe if area.parent.present?
  end

end
