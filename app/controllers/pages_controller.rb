
class PagesController < ApplicationController

  before_filter :authenticate_user!

  def home
    @users = User.all
  end
end
