
class PagesController < ApplicationController


  def home
    if user_signed_in?
      @users = User.all
    else
      render 'greeting'
    end
  end

end
