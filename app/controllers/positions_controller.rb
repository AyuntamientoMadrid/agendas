class PositionsController < AdminController

  autocomplete :position, :title, display_value: :full_name

  def get_autocomplete_items(parameters)
    Position.full_like("%#{parameters[:term]}%")
  end

end
