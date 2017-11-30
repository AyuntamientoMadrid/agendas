class EventsController < AdminController
  load_and_authorize_resource
  before_action :set_holders, only: [:new, :edit, :create]

  def index
    @events = current_user.admin? ? list_admin_events : list_user_events
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    if @event.save
      redirect_to events_path, notice: t('backend.successfully_created_record')
    else
      flash[:alert] = t('backend.review_errors')
      render :new
    end
  end

  def update
    debugger
    @event.user = current_user
    if @event.update_attributes(event_params)
      redirect_to events_path, notice: t('backend.successfully_updated_record')
    else
      set_holders
      flash[:alert] = t('backend.review_errors')
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: t('backend.successfully_destroyed_record')
  end

  def get_title
    Event.find(params[:id]).title if params[:action] == 'destroy'
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :location, :scheduled, :position_id, :search_title, :search_person,
                                  :lobby_activity, :notes, :status, :reasons, :published_at, :canceled_at,
                                  :organization_name,
                                  event_represented_entities_attributes: [:id, :name, :_destroy],
                                  event_agents_attributes: [:id, :name, :_destroy],
                                  attendees_attributes: [:id, :name, :position, :company, :_destroy],
                                  participants_attributes: [:id, :position_id, :_destroy],
                                  attachments_attributes: [:id, :title, :file, :_destroy])
  end

  def set_holders
    @participants = Position.current
    @holders = current_user.admin? ? @participants : current_user.holders
    @positions = current_user.admin? ? @participants : Position.current.holders(current_user.id)
  end

  def list_admin_events
    @events = Event.searches(params[:search_person], params[:search_title])
    @events.order(scheduled: :desc).page(params[:page]).per(50)
  end

  def list_user_events
    @events = Event.managed_by(current_user)
                   .includes(:position, :attachments, position: [:holder])
    @events.order(scheduled: :desc).page(params[:page]).per(50)
  end

end
