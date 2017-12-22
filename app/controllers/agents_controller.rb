class AgentsController < AdminController
  respond_to :json

  def index
    @agents = Agent.select('id', 'name', 'first_surname', 'second_surname').by_organization(params[:organization_id]).order(:name)
    render :json => @agents
  end
end
