class EventsController < AdminController
  load_and_authorize_resource
  before_action :set_holders, only: [:new, :edit, :create]

  def index
    @events = current_user.admin? ? list_admin_events : list_user_events
  end

  def list_admin_events
    @events = Event.searches(params)
    @events.order(scheduled: :desc).page(params[:page]).per(20)
  end

  def list_user_events
    @events = Event.by_manages(current_user.id)
    @events.page(params[:page]).per(20)
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

  private

  def event_params
    params.require(:event).permit(:title, :description, :location, :scheduled, :position_id, :search_title, :search_person, attendees_attributes: [:id, :name, :position, :company, :_destroy], participants_attributes: [:id, :position_id, :_destroy], attachments_attributes: [:id, :title, :file, :_destroy])
  end

  def set_holders
    @participants = Position.current
    @holders = current_user.admin? ? @participants : current_user.holders
    @positions = current_user.admin? ? @participants : Position.current.holders(current_user.id)
  end

end
