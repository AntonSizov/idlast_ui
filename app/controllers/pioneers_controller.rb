class PioneersController < ApplicationController

  def index
    @title = "My pioneers"
    @pioneers = current_user.pioneers.paginate(page: params[:page], per_page: 10)
  end

  def vectors
    @title = "Vector pioneers"
    @pioneers = Pioneer.where(approved: true, type: "vector").order_by(img_id: -1).paginate(page: params[:page], per_page: 10)
  end

  def illustrations
    @title = "Illustration pioneers"
    @pioneers = Pioneer.where(approved: true, type: "illustration").order_by(img_id: -1).paginate(page: params[:page], per_page: 10)
  end

  def photos
    @title = "Photo pioneers"
    @pioneers = Pioneer.where(approved: true, type: "photo").order_by(img_id: -1).paginate(page: params[:page], per_page: 10)
  end

  def new
    @title = "New pioneer"
    @pioneer = current_user.pioneers.new
  end

  def create
    @pioneer = current_user.pioneers.new(params[:pioneer])
    @pioneer.user_name = current_user.name
    approved_at = Time.new *flatten_datetime_array(params[:pioneer])
    @pioneer.approved_at = approved_at
    if @pioneer.save
      redirect_to(pioneers_path,
                  :notice => 'Pioneer was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
    @title = 'Edit pioneer'
    @pioneer = Pioneer.find(params[:id])
  end

  def update
    @pioneer = Pioneer.find(params[:id])
    approved_at = Time.new *flatten_datetime_array(params[:pioneer])
    @pioneer.approved_at = approved_at
    params[:pioneer][:approved_at] = approved_at
    if @pioneer.update_attributes(params[:pioneer])
      redirect_to(pioneers_path, :notice => 'Pioneer was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @pioneer = Pioneer.find(params[:id])
    @pioneer.destroy
    redirect_to(pioneers_url)
  end

  def vote_up
    Pioneer.vote(:voter_id => current_user.id, :votee_id => params[:id], :value => :up)
    redirect_to request.referer
  end

  def vote_down
    Pioneer.vote(:voter_id => current_user.id, :votee_id => params[:id], :value => :down)
    redirect_to request.referer
  end

  private

  def flatten_datetime_array hash
    %w(1 2 3 4 5).map { |e| hash["approved_at(#{e}i)"].to_i }
  end

end
