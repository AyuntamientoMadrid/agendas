class VisitorsController < ApplicationController

  def index
    events = search(params)
    @total = events.total
    @events1 = events.results
    @events = Event.where(id: events.hits.map(&:primary_key)).order("scheduled desc")

    #respond_to do |format|
    #  format.html { @events = @events.paginate(per_page: 5, page: params[:page]) }
    #  format.js { @events = @events.paginate(per_page: 5, page: params[:page]) }
    #  format.json { render json: @events, status: 200 }
    #  format.xml { }
    #end

  end

  def show
    @event = Event.find(params[:id]) unless !@event.active
  end

  private

  def search (params)
    Event.search do
      fulltext params[:keyword]
      with :area_id, params[:main_area] unless params[:main_area].blank?
      with(:scheduled).greater_than params[:from] unless params[:from].blank?
      with(:scheduled).less_than params[:to] unless params[:to].blank?
      order_by :scheduled, :desc
      paginate :page => params[:page] || 1, :per_page => 10
    end
  end

end
