class VisitorsController < ApplicationController

  def index
    events = search(params)
    @total = events.total
    @events1 = events.results
    @events = Event.includes(:position => [:holder,:area]).where(id: events.hits.map(&:primary_key)).order("scheduled desc")

    @tree = area_tree
    @holders = get_holders_by_area(params[:area])

    respond_to do |format|
      format.html
      format.csv { send_data @events.as_csv, filename: 'agenda.csv' }
    end

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
  end

  private

  def search (params)
    Event.search do
      fulltext params[:keyword] unless params[:keyword].blank?
      with :area_id, (Area.find(params[:area]).descendant_ids << Area.find(params[:area]).id) unless params[:area].blank?
      with :holder_id, params[:holder] unless params[:holder].blank?
      with(:scheduled).greater_than params[:from].to_date unless params[:from].blank?
      with(:scheduled).less_than params[:to].to_date unless params[:to].blank?
      order_by :score, :desc
      paginate page: params[:page] || 1, per_page: 10 unless params[:format].present?
    end
  end

  def area_tree
    Area.all.each { |c| c.ancestry = c.ancestry.to_s + (c.ancestry != nil ? "/" : '') + c.id.to_s
    }.sort {|x,y| x.ancestry <=> y.ancestry
    }.map{ |c| ["--"  * (c.depth - 1) + c.title,c.id]
    }.unshift([t('main.form.any'), ""])
  end

  def get_holders_by_area (area)
    Holder.where(id: Position.includes(:holder).area_filtered(area).current.map {|position| position.holder }).order(last_name: :asc)
  end

end
