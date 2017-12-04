class RepresentedEntitiesController < AdminController
  respond_to :json

  def index
    @represented_entities = RepresentedEntity.select('id', 'name').by_organization(params[:organization_id]).order(:name)
    render :json => @represented_entities
  end
end
