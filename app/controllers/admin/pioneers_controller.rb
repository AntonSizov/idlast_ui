class Admin::PioneersController < ApplicationController

  def index
    @title = "All pioneers"
    @pioneers = Pioneer.paginate(page: params[:page], per_page: 10)
    authorize! :index, @pioneers
  end

end
