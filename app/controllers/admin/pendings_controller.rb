class Admin::PendingsController < Admin::AdminController

  def index
    @title = "All pioneers"
    @pioneers = Pioneer.where(approved: false, :user_name.ne => "IDLast.com").order_by(created_at: -1).paginate(page: params[:page], per_page: 10)
    authorize! :index, @pioneers
  end

end
