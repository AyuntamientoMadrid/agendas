class Admin::AgentsController < AdminController
  respond_to :json

  def index
    @agents = Agent.select('id', 'name').by_organization(params[:organization_id]).order(:name)
    render :json => @agents
  end
end
