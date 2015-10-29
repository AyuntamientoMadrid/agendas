class EventsController < AdminController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = current_user.admin? ? Event.all : user.events
  end

  def new
    @event = Event.new
  end

  def show
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    if @event.save
      redirect_to events_path, notice: t('backend.successfully_created_record')
    else
      render :new, notice: t('backend.review_errors')
    end
  end

  def update
    if @event.update_attributes(event_params)
      redirect_to events_path, notice: t('backend.successfully_updated_record')
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: t('backend.successfully_destroyed_record')
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :location, :scheduled, :position_id, attendees_attributes: [:name, :position, :company, :_destroy])
  end

end
