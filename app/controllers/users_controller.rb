class UsersController < AdminController
  before_action :admin_only, :except => :show

  def index
    search = params[:q]
    search.downcase! unless search.nil?
    @users = User.active.user.where("lower(first_name) LIKE ? OR lower(last_name) like ?", "%#{search}%", "%#{search}%").order("last_name asc").paginate(:page => params[:page], :per_page => 5)


  end

  def search
    index

    render :index
  end

  def show
    @user = User.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to :back, :alert => "Access denied."
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private

  def admin_only
    unless current_user.admin?
      redirect_to :back, :alert => "Access denied."
    end
  end

  def secure_params
    params.require(:user).permit(:role)
  end

end
