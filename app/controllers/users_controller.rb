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
      redirect_to(@user, :notice => t(:pass_updated_msg))
    else
      redirect_to(@user, :alert => t(:pass_update_err_msg))
    end
  end

  def change_article_notification
    user = User.find(current_user.id)
    user.articles_notify = params[:user][:articles_notify]
    respond_to do |format|
      if user.save
        format.js
      else
        format.js
      end
    end
  end

end
