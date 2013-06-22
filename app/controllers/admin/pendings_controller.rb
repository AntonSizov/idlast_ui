class Admin::PendingsController < Admin::AdminController

  def index
    @title = "All pioneers"
    @pioneers = Pioneer.users_pending_sorted_by_created_at.paginate(page: params[:page], per_page: 10)
    authorize! :index, @pioneers
  end

end
