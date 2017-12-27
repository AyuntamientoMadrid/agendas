module Admin
  class OrganizationsController < AdminController

    load_and_authorize_resource

    before_action :set_organization, only: [:show, :update, :edit]

    def index
      @organizations = search(params)
      @paginated_organizations = Organization.where(id: @organizations.hits.map(&:primary_key)).order(created_at: :desc)
    end

    def show
      @legal_representant = @organization.legal_representant
      @user = @organization.user
      @represented_entities = @organization.represented_entities
      @interest = @organization.interests
      @agents = @organization.agents
    end

    def create
      @organization = Organization.new(organization_params)
      @organization.entity_type = 'lobby'
      if @organization.save
        UserMailer.welcome(@organization.user).deliver_now
        redirect_to admin_organizations_path, notice: t('backend.successfully_created_record')
      else
        flash[:alert] = t('backend.review_errors')
        render :new
      end
    end

    def new
      @organization = Organization.new
      @organization.user = User.new
    end

    def edit; end

    def update
      if @organization.update_attributes(organization_params)
        path = current_user.lobby? ? admin_organization_path(@organization) : admin_organizations_path
        @organization.send_update_mail
        redirect_to path, notice: t('backend.successfully_updated_record')
      else
        flash[:alert] = t('backend.review_errors')
        render :edit, show: params[:show]
      end
    end

    def destroy
      @organization = Organization.find(params[:id])
      @organization.canceled_at = Time.zone.now
      @organization.user.soft_deleted

      if @organization.save
        redirect_to admin_organizations_path,
                    notice: t('backend.successfully_destroyed_record')
      else
        flash[:alert] = t('backend.unable_to_perform_operation')
        redirect_to admin_organizations_path
      end
    end

    private

      def organization_params
        params.require(:organization)
              .permit(:reference, :identifier, :name, :first_surname, :second_surname,
                      :phones, :email, :invalidate, :invalidated_reasons,
                      :web, :address_type, :address, :number, :gateway, :stairs, :floor, :door, :validate,
                      :postal_code, :town, :province, :description, :category_id,
                      :fiscal_year, :range_fund, :subvention, :contract, :country,
                      :certain_term, :code_of_conduct_term, :gift_term, :lobby_term,
                      legal_representant_attributes: [:identifier, :name, :first_surname, :second_surname, :phones, :email, :_destroy],
                      user_attributes: [:id, :first_name, :last_name, :role, :email, :active, :phones, :password, :password_confirmation],
                      represented_entities_attributes: [:id, :identifier, :name, :first_surname, :second_surname,
                                                        :from, :fiscal_year, :range_fund, :subvention, :contract, :_destroy],
                      attachments_attributes: [:id, :file, :_destroy],
                      interest_ids: [], registered_lobby_ids: [])
      end

      def set_organization
        @organization = Organization.find(params[:id])
      end

      def search(params)
        Organization.search do
          fulltext params[:keyword] if params[:keyword].present?
          order_by :created_at, :desc
          paginate page: params[:format].present? ? 1 : params[:page] || 1, per_page: params[:format].present? ? 1000 : 10
        end
      end

  end
end
