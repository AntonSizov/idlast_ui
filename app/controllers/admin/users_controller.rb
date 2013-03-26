class Admin::UsersController < ApplicationController

# http://stackoverflow.com/questions/9245258/adding-controllers-with-a-namespace-admin-as-a-subfolder
# http://stackoverflow.com/questions/10165934/properly-rendering-multiple-layouts-per-controller-in-rails
# http://stackoverflow.com/questions/5090084/rails-3-how-add-a-view-that-does-not-use-same-layout-as-rest-of-app

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @user = User.new
    @current_method = "new"
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to(@user, :notice => 'User was successfully created.')
    else
      render :action => "new"
    end
  end

  def show
    @user = User.find(params[:id])
  end


end
