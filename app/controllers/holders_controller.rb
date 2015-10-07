class HoldersController < AdminController
  before_action :set_holder, only: [:show, :edit, :update, :destroy]

  def index
    search = params[:q]
    search.downcase! unless search.nil?
    @holders = Holder.where("lower(first_name) LIKE ? OR lower(last_name) like ?", "%#{search}%", "%#{search}%").order("last_name asc").paginate(:page => params[:page], :per_page => 5)


  end

  def search
    index

    render :index
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
      redirect_to edit_holder_path(@holder), notice: 'Holder was successfully created.'
    else
      render :new
    end
  end

  def update
    if @holder.update(holder_params)
      redirect_to holders_path, notice: 'Holder was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @holder.destroy
    redirect_to admin_holders_url, notice: 'Holder was successfully destroyed.'
  end

  private
    def set_holder
      @holder = Holder.find(params[:id])
    end

    def holder_params
      params.require(:holder).permit(:first_name, :last_name, :id)
    end
end
