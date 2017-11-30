module Admin
  class OrganizationsController < AdminController

    load_and_authorize_resource

    before_action :set_organization, only: [:update, :edit,]

    autocomplete :organization, :name

    def index
      @organizations = search(params)
      @paginated_organizations = Organization.all.where(id: @organizations.hits.map(&:primary_key)).order(created_at: :desc)
    end

    def show
      @organization = Organization.find(params[:id])
      render :json => [@organization.category.name]
    end

    def create
      @organization = Organization.new(organization_params)
      @organization.entity_type = 'lobby'
      if @organization.save
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
        redirect_to admin_organizations_path, notice: t('backend.successfully_updated_record')
      else
        flash[:alert] = t('backend.review_errors')
        render :edit
      end
    end

    def destroy
      @organization = Organization.find(params[:id])
      @organization.canceled_at = Time.zone.now
      User.soft_destroy(@organization)

      if @organization.save
        redirect_to admin_organizations_path,
                    notice: t('backend.successfully_destroyed_record')
      else
        flash[:alert] = t('backend.unable_to_perform_operation')
        redirect_to admin_organizations_path
      end
    end

    def get_autocomplete_items(parameters)
      items = Organization.full_like("%#{parameters[:term]}%")
    end

    private

      def organization_params
        params.require(:organization)
              .permit(:reference, :identifier, :name, :first_surname, :second_surname, :phones, :email,
                      :web, :address_type, :address, :number, :gateway, :stairs, :floor, :door,
                      :postal_code, :town, :province, :description, :registered_lobbies, :category_id,
                      :fiscal_year, :range_fund, :subvention, :contract, :denied_public_data, :denied_public_events, interest_ids: [],
                      legal_representant_attributes: [:identifier, :name, :first_surname, :second_surname, :phones, :email, :_destroy],
                      user_attributes: [:id, :first_name, :last_name, :role, :email, :active, :phones, :password, :password_confirmation],
                      represented_entities_attributes: [:id, :identifier, :name, :first_surname, :second_surname,
                                                        :from, :fiscal_year, :range_fund, :subvention, :contract, :_destroy],
                      organization_interests_attributes: [:interest_ids],
                      agents_attributes: [:id, :identifier, :name, :first_surname, :second_surname, :from,
                                          :to, :public_assignments, :_destroy])
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
