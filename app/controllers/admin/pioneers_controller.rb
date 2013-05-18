class Admin::PioneersController < Admin::AdminController

  def index
    @title = "All pioneers"
    @pioneers = Pioneer.where(approved: true).order_by(img_id: -1).paginate(page: params[:page], per_page: 10)
    authorize! :index, @pioneers
  end

end
