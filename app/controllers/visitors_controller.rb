class VisitorsController < ApplicationController

  def index
    events = search(params)
    @total = events.total
    @events1 = events.results
    @events = Event.where(id: events.hits.map(&:primary_key)).order("scheduled desc")

    @categories = Area.all.each { |c| c.ancestry = c.ancestry.to_s + (c.ancestry != nil ? "/" : '') + c.id.to_s
    }.sort {|x,y| x.ancestry <=> y.ancestry
    }.map{ |c| ["--"  * (c.depth - 1) + c.title,c.id]
    }.unshift([t('main.form.any'), ""])

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
    @holders = Position.area_filtered(params[:id])
  end

  def contact
  end

  private

  def search (params)
    Event.search do
      fulltext params[:keyword]
      with :area_id, params[:main_area] unless params[:main_area].blank?
      with :holder_id, params[:holder] unless params[:holder].blank?
      with(:scheduled).greater_than params[:from] unless params[:from].blank?
      with(:scheduled).less_than params[:to] unless params[:to].blank?
      order_by :score, :desc
      order_by :scheduled, :desc
      paginate page: params[:page] || 1, per_page: 10 unless params[:format].present?
    end
  end

end
