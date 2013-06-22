class Admin::PioneersController < Admin::AdminController

  def index
    @title = "All pioneers"
    @pioneers = Pioneer.approved_sorted_by_img_id.paginate(page: params[:page], per_page: 10)
    authorize! :index, @pioneers
  end

end
