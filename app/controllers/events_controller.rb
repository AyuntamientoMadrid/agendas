class EventsController < AdminController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def new
    @event = Event.new
  end

  def index
    search = params[:q]
    search.downcase! unless search.nil?
    @events = Event.where("lower(title) LIKE ? OR lower(description) like ?", "%#{search}%", "%#{search}%").order("scheduled asc")
  end

  def search
    index
    render :index
  end

  def create
    @event = Event.new(event_params)
    @event.password = Faker::Internet.password(8)
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

  def admin_only
    unless current_event.admin?
      redirect_to :back, :alert => "Access denied."
    end
  end

  def event_params
    params.require(:event).permit(:first_name, :last_name, :email, :id)
  end

end
