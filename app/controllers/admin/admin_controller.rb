class Admin::AdminController < ApplicationController

before_filter :only_admin

private
  def only_admin
    redirect_to(user_path(current_user), :alert => 'Access denied') if !current_user.admin
  end
end
