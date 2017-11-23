module Admin
  class OrganizationsController < AdminController

    load_and_authorize_resource

    def index
      @organizations = Organization.all.page(params[:page]).per(25)
    end

    def create
      @organization = Organization.new(organization_params)
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


    private

    def organization_params
      params.require(:organization)
            .permit(:reference, :identifier, :name, :first_name, :last_name, :phones, :email,
                    :web, :address_type, :address, :number, :gateway, :stairs, :floor, :door,
                    :postal_code, :town, :province, :description, :registered_lobbies, :category_id,
                    :fiscal_year, :range_fund, :subvention, :contract, :denied_public_data, :denied_public_events, interest_ids: [],
                    legal_representant_attributes: [:id, :identifier, :name, :first_name, :last_name, :phones, :email],
                    user_attributes: [:id, :first_name, :last_name, :role, :email, :active, :phones, :password, :password_confirmation],
                    represented_entities_attributes: [:id, :identifier, :name, :first_name, :last_name, :from, :fiscal_year, :range_fund, :subvention, :contract],
                    organization_interests_attributes: [:interest_ids],
                    agents_attributes: [:id, :identifier, :name, :first_name, :last_name, :from, :to, :public_assignments])
    end

  end  

end
