class ActivitiesController < AdminController

  before_filter(:only => :index) { unauthorized! if cannot? :index, :activities }

  def index
    @activities = PublicActivity::Activity.all
  end

end
