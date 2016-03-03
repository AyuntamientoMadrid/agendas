class AreasController < AdminController
  load_and_authorize_resource
  before_action :set_area, only: [:show, :edit, :update, :destroy]

  def index
    @areas = Area.roots.order(:title)
  end


  def new
  end

  def create
    @area = Area.new(area_params)
    if @area.save
      redirect_to areas_path, notice: t('backend.successfully_created_record')
    else
      flash[:alert] = t('backend.review_errors')
      render :new
    end
  end

  def update
    if @area.update_attributes(area_params)
      redirect_to areas_path, notice: t('backend.successfully_updated_record')
    else
      flash[:alert] = t('backend.review_errors')
      render :edit
    end
  end

  def destroy
    @area.destroy
    redirect_to areas_path, notice: t('backend.successfully_destroyed_record')
  end

  private

  def set_area
    @user = Area.find(params[:id])
  end

  def area_params
    params.require(:area).permit(:title, :parent_id)
  end

end
