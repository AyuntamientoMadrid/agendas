class EventsController < AdminController
  load_and_authorize_resource
  before_action :set_holders, only: [:new, :edit, :create]
  before_action :set_event, only: [:edit, :update]

  def index
    @events = current_user.admin? || current_user.lobby? ? list_admin_events : list_user_events
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    if @event.save
      redirect_to events_home_path(current_user),
                  notice: t('backend.successfully_created_record')
    else
      flash[:alert] = t('backend.review_errors')
      render :new
    end
  end

  def new
    if current_user.lobby? && current_user.organization.agents.empty?
      redirect_to admin_organization_organization_interests_path(current_user.organization), alert: t('backend.event.add_agents')
    end
  end

  def edit; end

  def update
    @event.user = current_user
    if @event.update_attributes(event_params)
      redirect_to events_home_path(current_user),
                  notice: t('backend.successfully_updated_record')
    else
      set_holders
      flash[:alert] = t('backend.review_errors')
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_home_path(current_user),
                notice: t('backend.successfully_destroyed_record')
  end

  def get_title
    Event.find(params[:id]).title if params[:action] == 'destroy'
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :location, :scheduled, :position_id, :search_title, :search_person,
                                  :lobby_activity, :notes, :status, :canceled_reasons, :published_at, :cancel, :decline,
                                  :declined_reasons, :organization_id, :organization_name, :lobby_scheduled, :general_remarks,
                                  :lobby_contact_firstname, :accept, :lobby_contact_lastname,
                                  :lobby_contact_phone, :lobby_contact_email, :manager_general_remarks,
                                  event_represented_entities_attributes: [:id, :name, :_destroy],
                                  event_agents_attributes: [:id, :name, :_destroy],
                                  attendees_attributes: [:id, :name, :position, :company, :_destroy],
                                  participants_attributes: [:id, :position_id, :_destroy],
                                  attachments_attributes: [:id, :title, :file, :public, :description, :_destroy])
  end

  def set_holders
    @participants = Position.current
    @holders = current_user.admin? ? @participants : current_user.holders
    @positions = current_user.admin? || current_user.lobby? ? @participants : Position.current.holders(current_user.id)
  end

  def list_admin_events
    @events = Event.searches(search_params(params))
    @events.order(scheduled: :desc).page(params[:page]).per(50)
  end

  def list_user_events
    params[:status] = ["requested", "accepted", "done"] unless params[:status].present?
    @events = Event.managed_by(current_user).searches(search_params(params))
                   .includes(:position, :attachments, position: [:holder])
    @events.order(scheduled: :desc).page(params[:page]).per(50)
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def find_holder_id_by_name(name)
    holder_ids = Holder.by_name(name).pluck(:id)
    Position.where("positions.holder_id IN (?)", holder_ids)
  end

  def enum_status(array_status)
    @status = array_status.map { |status| Event.statuses[status] }.join(' , ') if array_status.present?
  end

  def search_params(params)
    person = params[:search_person]
    title = params[:search_title]
    status = enum_status(params[:status])
    params_searches = {}
    params_searches[:title] = title unless title.blank?
    params_searches[:lobby_activity] = "1" unless params[:lobby_activity].blank?
    params_searches[:status] = status if status.present?
    params_searches[:position_id] = find_holder_id_by_name(person) if person.present?
    params_searches[:organization_id] = current_user.organization_id if current_user.role == "lobby"
    params_searches
  end

end
