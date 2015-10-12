class AreasController < AdminController
  before_action :authenticate_user!
  before_action :admin_only
  before_action :set_area, only: [:show, :edit, :update, :destroy]

  def index
    @areas = Area.main_areas
  end

  def show
  end

  def new
  end

  def create
  end

  def update
  end

  def delete
  end

  private

  def set_area
    @user = Area.find(params[:id])
  end

  def area_params
    params.require(:area).permit(:title, :parent_id)
  end

end
