class EventsController < AdminController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def new
    @event = Event.new
  end

  def index
    @events = Event.all
  end

  def create
    @event = Event.new(event_params)
    @event.active = true
    if @event.save
      @event.event!
      redirect_to events_path, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
      redirect_to events_path, :notice => "Event updated."
    else
      redirect_to events_path, :alert => "Unable to update event."
    end
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy
    redirect_to events_path, :notice => "Event deleted."
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:first_name, :last_name, :email, :id)
  end

end
