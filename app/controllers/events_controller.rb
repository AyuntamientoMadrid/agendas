class EventsController < AdminController
  require 'will_paginate/array'
  load_and_authorize_resource
  #before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_holders, only: [:new, :edit, :create]

  def index
    @events = current_user.admin? ?  list_admin_events : list_user_events
  end

  def list_admin_events
    if params[:search_person].present?
      @events = []
      Holder.by_name(params[:search_person]).each do |h|
        h.positions.each do |p|
          @events += p.events
        end
      end
    end
    if params[:search_title].present?
      @events = Event.by_title(params[:search_title])
    end
    @events.paginate(:page => params[:page], :per_page => 20)
  end

  def list_user_events
    current_user.events.order(scheduled: :desc).paginate(:page => params[:page], :per_page => 20)
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

  def event_params
    params.require(:event).permit(:title, :description, :location, :scheduled, :position_id, :search_title, :search_person, attendees_attributes: [:id, :name, :position, :company, :_destroy], participants_attributes: [:id, :position_id, :_destroy], attachments_attributes: [:id, :title, :file, :_destroy])
  end

  def set_holders
    @participants = Holder.all
    @holders = current_user.admin? ? @participants : current_user.holders
  end

end
