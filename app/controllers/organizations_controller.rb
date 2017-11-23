class OrganizationsController < ApplicationController

  def index
    @organizations = search(params)
    @paginated_organizations = Organization.all.where(id: @organizations.hits.map(&:primary_key)).order(created_at: :desc)
  end

  private

    def search(params)
      Organization.search do
        order_by :created_at, :desc
        paginate page: params[:format].present? ? 1 : params[:page] || 1, per_page: params[:format].present? ? 1000 : 10
      end
    end

end
