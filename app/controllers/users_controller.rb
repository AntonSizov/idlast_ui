 class UsersController < ApplicationController

  load_and_authorize_resource

  def show
    @user = User.find(current_user.id)
  end

  # http://stackoverflow.com/questions/6607834/rails-3-devise-manually-change-password
  def update_pass
    @user = User.find(current_user.id)
    if @user.update_with_password(params[:user])
      sign_in(@user, :bypass => true)
      redirect_to(@user, :notice => 'Password successfully updated.')
    else
      redirect_to(@user, :alert => 'Something went wrong!')
    end
  end

end
