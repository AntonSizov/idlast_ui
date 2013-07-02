class Admin::PioneersController < Admin::AdminController

  def index
    @title = "All pioneers"
    @pioneers = Pioneer.approved_sorted_by_img_id.paginate(page: params[:page], per_page: 20)
    authorize! :index, @pioneers
  end

  def destroy
    @pioneer = Pioneer.find(params[:id])
    @pioneer.destroy
    redirect_to(request.referer)
  end


end
