class Admin::UsersController < Admin::AdminController

# http://stackoverflow.com/questions/9245258/adding-controllers-with-a-namespace-admin-as-a-subfolder
# http://stackoverflow.com/questions/10165934/properly-rendering-multiple-layouts-per-controller-in-rails
# http://stackoverflow.com/questions/5090084/rails-3-how-add-a-view-that-does-not-use-same-layout-as-rest-of-app

  def index
    @title = "All users"
    @users = User.sorted_by_created_at.paginate(page: params[:page], per_page: 20)
    authorize! :index, @users
  end

  def new
    @user = User.new
    @current_method = "new"
    authorize! :create, @user
  end

  def edit
    @user = User.find(params[:id])
    authorize! :edit, @user
  end

  def create
    @user = User.new(params[:user])
    authorize! :create, @user
    if @user.save
      redirect_to(@user, notice: 'User was successfully created.')
    else
      render action: "new"
    end
  end

  def show
    @user = User.find(params[:id])
    authorize! :show, @user
  end


end
