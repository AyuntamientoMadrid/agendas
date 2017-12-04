class VisitorsController < ApplicationController

  require 'ext/string'

  def index
    get_events
    @tree = ancestry_options(Area.unscoped.arrange(:order => 'title')) {|i| "#{'-' * i.depth} #{i.title}" }
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
    @paginated_events = Event.unpublished.includes(:position => [:holder,:area]).where(id: @events.hits.map(&:primary_key)).order(scheduled: :desc)
    @paginated_events =  @paginated_events.sort_by {|m| @events.hits.index(m.id)} if params[:order] == 'score'
  end

  def search (params)
    Event.search do
      fulltext params[:keyword] if params[:keyword].present?
      with :area_id, (Area.find(params[:area]).descendant_ids << Area.find(params[:area]).id) if params[:area].present?
      with :holder_id, params[:holder] if params[:holder].present?
      with :lobby_activity, params[:lobby_activity] if params[:lobby_activity].present?
      all_of do
        with(:scheduled).greater_than_or_equal_to params[:from].to_date if params[:from].present?
        with(:scheduled).less_than_or_equal_to params[:to].to_date.end_of_day() if params[:to].present?
      end
      with(:published_at).greater_than_or_equal_to Time.zone.today
      order_by params[:order].blank? ? :scheduled : params[:order], :desc
      paginate page: params[:format].present? ? 1 : params[:page] || 1, per_page: params[:format].present? ? 1000 : 10
    end
  end

  def get_holders_by_area(area)
    holders_ids = Position.includes(:holder)
                          .area_filtered(area)
                          .current.map {|position| position.holder }
    Holder.where(id: holders_ids).order(last_name: :asc)
  end

  def ancestry_options(items)
    result = []
    items.map do |item, sub_items|
      result << [yield(item), item.id]
      result += ancestry_options(sub_items) {|i| "#{'-' * i.depth} #{i.title}" }
    end
    result
  end

end
