class PagesController < ApplicationController

  def home
    redirect_to :controller => "pioneers", :action => "vectors" if user_signed_in?
  end

  def about_us
    @title = t(:about_us_h)
  end

end
