class VisitorsController < ApplicationController

  require 'csv'

  def index
    get_events
    @tree = Area.area_tree
    @holders = get_holders_by_area(params[:area])
  end

  def show
    @event = Event.friendly.find(params[:id])
  end

  def agenda
    index
    render :index
  end

  def update_holders
    @holders = get_holders_by_area(params[:id])
  end

  private

  def get_events
    @events = search(params)
    @paginated_events = Event.includes(:position => [:holder,:area]).where(id: @events.hits.map(&:primary_key)).order(scheduled: :desc)
    @paginated_events =  @paginated_events.sort_by {|m| @events.hits.index(m.id)} if params[:order] == 'score'
  end

  def search (params)
    Event.search do
      fulltext params[:keyword] unless params[:keyword].blank?
      with :area_id, (Area.find(params[:area]).descendant_ids << Area.find(params[:area]).id) unless params[:area].blank?
      with :holder_id, params[:holder] unless params[:holder].blank?
      with(:scheduled).greater_than params[:from].to_date unless params[:from].blank?
      with(:scheduled).less_than params[:to].to_date unless params[:to].blank?
      order_by params[:order].blank? ? :scheduled : params[:order], :desc
      paginate page: params[:format].present? ? 1 : params[:page] || 1, per_page: params[:format].present? ? 1000 : 10
    end
  end

  def get_holders_by_area (area)
    Holder.where(id: Position.includes(:holder).area_filtered(area).current.map {|position| position.holder }).order(last_name: :asc)
  end

end
