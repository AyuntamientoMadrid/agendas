class ActivitiesController < AdminController

  before_filter(:only => :index) { unauthorized! if cannot? :index, :activities }

  def index
    @activities = PublicActivity::Activity.order(updated_at: :desc).paginate(:page => params[:page], :per_page => 20)
  end

end
