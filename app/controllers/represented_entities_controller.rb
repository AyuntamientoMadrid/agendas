class RepresentedEntitiesController < AdminController
  respond_to :json

  def index
  @represented_entities = RepresentedEntity.select('id', 'name', 'first_surname', 'second_surname').where(to: nil).by_organization(params[:organization_id]).order(:name)
    render :json => @represented_entities
  end
end
