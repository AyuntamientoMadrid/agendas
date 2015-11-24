class VisitorsController < ApplicationController

  require 'csv'

  def index
    @events = search(params)
    @paginated_events = set_order(Event.includes(:position => [:holder,:area]).where(id: @events.hits.map(&:primary_key)))
    @tree = Area.area_tree
    @holders = get_holders_by_area(params[:area])
  end

  def show
    @event = Event.friendly.find(params[:id])
  end

  def update_areas
    @areas = Area.filtered(params[:id])
  end

  def update_holders
    @holders = get_holders_by_area(params[:id])
  end

  def contact
    @message = ContactMessage.new
  end

  private

  def search (params)
    Event.search do
      fulltext params[:keyword] unless params[:keyword].blank?
      with :area_id, (Area.find(params[:area]).descendant_ids << Area.find(params[:area]).id) unless params[:area].blank?
      with :holder_id, params[:holder] unless params[:holder].blank?
      with(:scheduled).greater_than params[:from].to_date unless params[:from].blank?
      with(:scheduled).less_than params[:to].to_date unless params[:to].blank?
      order_by params[:order].blank? ? :scheduled : params[:order], :desc
      paginate page: params[:page] || 1, per_page: 10 unless params[:format].present?
    end
  end

  def get_holders_by_area (area)
    Holder.where(id: Position.includes(:holder).area_filtered(area).current.map {|position| position.holder }).order(last_name: :asc)
  end

  def set_order(events)
    if params[:order].blank? or params[:order] == 'scheduled'
      events.order(scheduled: :desc)
    else
      events.sort_by {|m| @events.hits.index(m.id)}
    end
  end

end
