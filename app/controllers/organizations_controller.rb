class OrganizationsController < ApplicationController

  before_action :set_organization, only: :show

  autocomplete :organization, :name

  def index
    @organizations = search(params)
    @paginated_organizations = Organization.lobbies.validated.where(id: @organizations.hits.map(&:primary_key))
    params[:order] ||= 4
    @paginated_organizations = @paginated_organizations.reorder(sorting_option(params[:order]))

  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: [@organization.category.name] }
    end
  end

  def new; end

  def edit; end

  def destroy; end

  private

    def search(params)
      Organization.search do
        with(:canceled_at, nil)
        with(:entity_type_id, 2)
        with(:invalidate, false)
        with(:interest_ids, params[:interests]) if params[:interests].present?
        with(:category_id, params[:category]) if params[:category].present?
        with(:lobby_activity, true) if params[:lobby_activity].present?
        any do
          fulltext params[:keyword] if params[:keyword].present?
          fulltext(params[:keyword], :fields => [:agent_name]) if params[:keyword].present?
          fulltext(params[:keyword], :fields => [:agent_first_surname]) if params[:keyword].present?
          fulltext(params[:keyword], :fields => [:agent_second_surname]) if params[:keyword].present?
        end
        order_by :created_at, :desc
        paginate page: params[:format].present? ? 1 : params[:page] || 1, per_page: params[:format].present? ? 1000 : 20
      end
    end

    def set_organization
      if current_user.try(:admin?)
        @organization = Organization.find(params[:id])
      else
        @organization = Organization.validated.find(params[:id])
      end
    end

    def get_autocomplete_items(parameters)
      items = Organization.full_like("%#{parameters[:term]}%")
    end

    def sorting_option(option)
      case option
      when '1'
        'name ASC'
      when '2'
        'name DESC'
      when '3'
        'inscription_date ASC'
      when '4'
        'inscription_date DESC'
      else
        'inscription_date DESC'
      end
    end

end
