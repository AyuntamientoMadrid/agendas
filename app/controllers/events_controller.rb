class EventsController < AdminController
  load_and_authorize_resource
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_holders, only: [:new, :edit, :create]

  def index
    @events = current_user.admin? ? Event.all : current_user.events
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
      flash[:alert] = t('backend.review_errors')
      render :new
    end
  end

  def update
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

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :location, :scheduled, :position_id, attendees_attributes: [:id, :name, :position, :company, :_destroy], participants_attributes: [:id, :position_id, :_destroy], attachments_attributes: [:id, :title, :file, :_destroy])
  end

  def set_holders
    @participants = Holder.all
    @holders = current_user.admin? ? @participants : current_user.holders
  end

end
