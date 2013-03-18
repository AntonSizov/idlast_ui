 class UsersController < ApplicationController

  #load_and_authorize_resource
  before_filter :authenticate_user!

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    @current_method = "new"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to(@user, :notice => 'User was successfully created.')
    else
      render :action => "new"
    end
  end

  # http://stackoverflow.com/questions/6607834/rails-3-devise-manually-change-password
  def update_pass
    @user = User.find(params[:id])
    if @user.update_with_password(params[:user])
      sign_in(@user, :bypass => true)
      redirect_to(@user, :notice => 'Password successfully updated.')
    else
      redirect_to @user
    end
  end

end
