class OrganizationsController < ApplicationController

  before_action :set_organization, only: :show

  autocomplete :organization, :name

  def index
    selected_order = params[:order] == "descending" ? :desc : :asc
    @organizations = search(params, selected_order)
    @paginated_organizations = Organization.validated.all.where(id: @organizations.hits.map(&:primary_key))
    @paginated_organizations = @paginated_organizations.reorder(inscription_date: selected_order)
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: [@organization.category.name] }
    end
  end

  private

    def search(params, selected_order)
      Organization.validated.search do
        fulltext params[:keyword] if params[:keyword].present?
        with(:entity_type, params[:entity_type]) if params[:entity_type].present?
        with(:interest_ids, params[:interests]) if params[:interests].present?
        order_by :created_at, :desc
        order_by :inscription_date, selected_order
        paginate page: params[:format].present? ? 1 : params[:page] || 1, per_page: params[:format].present? ? 1000 : 10
      end
    end

    def set_organization
      @organization = Organization.validated.find(params[:id])
    end

    def get_autocomplete_items(parameters)
      items = Organization.full_like("%#{parameters[:term]}%")
    end

end
