class OrganizationsController < ApplicationController

  before_action :set_organization, only: :show

  def index
    @organizations = search(params)
    @paginated_organizations = Organization.all.where(id: @organizations.hits.map(&:primary_key)).order(created_at: :desc)
  end

  def show
  end

  private

    def search(params)
      Organization.validated.search do
        fulltext params[:keyword] if params[:keyword].present?
        order_by :created_at, :desc
        paginate page: params[:format].present? ? 1 : params[:page] || 1, per_page: params[:format].present? ? 1000 : 10
      end
    end

    def set_organization
      @organization = Organization.validated.find(params[:id])
    end

end

