class HoldersController < AdminController
  before_action :set_holder, only: [:show, :edit, :update, :destroy]

  def index
    @holders = Holder.all
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
      redirect_to @holder, notice: 'Holder was successfully created.'
    else
      render :new
    end
  end

  def update
    if @holder.update(holder_params)
      redirect_to @holder, notice: 'Holder was successfully updated.'
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
      params[:admin_holder]
    end
end
