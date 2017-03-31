class ActivitiesController < AdminController

  before_filter(:only => :index) { unauthorized! if cannot? :index, :activities }

  def index
    @activities = PublicActivity::Activity.order(updated_at: :desc).page(params[:page]).per(50)
  end

end
