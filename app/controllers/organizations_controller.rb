class OrganizationsController < ApplicationController

  before_action :set_organization, only: :show

  def index
    selected_order = params[:order] == "descending" ? :desc : :asc
    @organizations = search(params, selected_order)
    @paginated_organizations = Organization.all.where(id: @organizations.hits.map(&:primary_key))
    @paginated_organizations = @paginated_organizations.reorder(inscription_date: selected_order)
  end

  def show; end

  private

    def search(params, selected_order)
      Organization.search do
        fulltext params[:keyword] if params[:keyword].present?
        with :entity_type, params[:entity_type] unless params[:entity_type].blank?
        order_by :created_at, :desc
        order_by :inscription_date, selected_order
        paginate page: params[:format].present? ? 1 : params[:page] || 1, per_page: params[:format].present? ? 1000 : 10
      end
    end

    def set_organization
      @organization = Organization.find(params[:id])
    end

end
