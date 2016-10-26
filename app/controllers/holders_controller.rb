class HoldersController < AdminController
  load_and_authorize_resource
  before_action :set_holder, only: [:show, :edit, :update, :destroy]
  before_action :load_areas

  def index
    @holders = Holder.includes(:users, :positions, :manages).order(last_name: :asc).paginate(:page => params[:page], :per_page => 20)
  end

  def show
  end

  def new
    @holder = Holder.new
  end

  def edit
  end

  def create
    @holder = Holder.new(holder_params)
    if @holder.save
      redirect_to edit_holder_path(@holder), notice: t('backend.successfully_created_record')
    else
      flash[:alert] = t('backend.review_errors')
      render :new
    end
  end

  def update
    if @holder.update(holder_params)
      redirect_to holders_path, notice: t('backend.successfully_updated_record')
    else
      flash[:alert] = t('backend.review_errors')
      render :edit
    end
  end

  def destroy
    @holder.destroy
    redirect_to holders_path, notice: t('backend.successfully_destroyed_record')
  end

  private

  def set_holder
    @holder = Holder.find(params[:id])
  end

  def holder_params
    params.require(:holder).permit(:first_name, :last_name, :id, positions_attributes: [:id, :holder_id, :title, :area_id, :from, :to, :_destroy])
  end

  def load_areas
    @areas = Area.area_tree
  end
end
