class UsersController < AdminController
  load_and_authorize_resource
  before_action :load_holders, only: [:new, :edit, :update, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :disable]

  def new
    @user = User.new
  end

  def index
    @users = User.includes(:manages => :holder).order(last_name: :asc)
  end

  def create
    @user = User.new(user_params)
    @user.password = Faker::Internet.password(8)
    if @user.save
      redirect_to users_path, notice: t('backend.successfully_created_record')
    else
      flash[:alert] = t('backend.review_errors')
      render :new
    end
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to users_path, notice: t('backend.successfully_updated_record')
    else
      flash[:alert] = t('backend.review_errors')
      render :edit
    end
  end

  def destroy
    if current_user == @user
      redirect_to users_path, alert: t('backend.unable_to_perform_operation')
    else
      @user.destroy
      redirect_to users_path, notice: t('backend.successfully_destroyed_record')
    end
  end

  def disable
    @user.status = false
    @user.save
    redirect_to users_path, notice: t('backend.successfully_disabled_record')
  end

  def import
    UwebImportWorker.perform_async
    redirect_to users_path, notice: t('backend.successfully_sync')
  end

  def full_name
    (self.first_name.to_s+' '+self.last_name.to_s).mb_chars.to_s
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :id, manages_attributes: [:id, :holder_id, :_destroy])
  end

  def load_holders
    @holders = Holder.all.order("last_name asc")
  end

end
