module Admin
  class AgentsController < AdminController
    load_and_authorize_resource :organization
    load_and_authorize_resource :agent, through: :organization

    def index
      @agents = @organization.agents
    end

    def new
      @agent = Agent.new
      @agent.attachments.build
    end

    def create
      @agent = Agent.new(agent_params)
      @agent.organization = @organization

      if @agent.save
        redirect_to admin_organization_agents_path(@organization),
                    notice: t('backend.successfully_created_record')
      else
        if @agent.errors.messages[:"attachments.file"]
          @agent.errors.add :attachments, "Debe proporcionar el documento acreditativo de los permisos."
        end
        flash[:alert] = t('backend.review_errors')
        render :new
      end
    end

    def edit; end

    def update
      if @agent.update_attributes(agent_params)
        redirect_to admin_organization_agents_path(@organization),
                    notice: t('backend.successfully_updated_record')
      else
        flash[:alert] = t('backend.review_errors')
        render :edit
      end
    end

    def destroy
      @agent = Agent.find(params[:id])

      if @agent.destroy
        redirect_to admin_organization_agents_path(@organization),
                    notice: t('backend.successfully_destroyed_record')
      else
        flash[:alert] = t('backend.unable_to_perform_operation')
        redirect_to admin_organization_agents_path
      end
    end

    private

      def agent_params
        params.require(:agent)
              .permit(:identifier, :name, :first_surname, :second_surname, :from,
                      :to, :public_assignments, :_destroy, :allow_public_data,
                      interests_attributes: [:interest_ids],
                      attachments_attributes: [:id, :title, :file, :public,
                                               :description, :_destroy])
      end

  end
end
