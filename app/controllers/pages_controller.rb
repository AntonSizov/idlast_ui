class PagesController < ApplicationController

  def home
    redirect_to :controller => "pioneers", :action => "vectors" if user_signed_in?
  end

  def about_us
  end

end
