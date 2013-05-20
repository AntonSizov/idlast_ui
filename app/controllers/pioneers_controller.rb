class PioneersController < ApplicationController

  load_and_authorize_resource

  def index
    @title = t(:my_pioneers)
    @pioneers = current_user.pioneers.where(approved: true).order_by(img_id: -1).paginate(page: params[:page], per_page: 10)
    @pendings = current_user.pioneers.where(approved: false)
  end

  def vectors
    @title = t(:vectors)
    @pioneers = Pioneer.where(approved: true, type: "vector").order_by(img_id: -1).paginate(page: params[:page], per_page: 10)
  end

  def illustrations
    @title = t(:illustrations)
    @pioneers = Pioneer.where(approved: true, type: "illustration").order_by(img_id: -1).paginate(page: params[:page], per_page: 10)
  end

  def photos
    @title = t(:photos)
    @pioneers = Pioneer.where(approved: true, type: "photo").order_by(img_id: -1).paginate(page: params[:page], per_page: 10)
  end

  def new
    @title = t(:new_pioneer)
    @pioneer = current_user.pioneers.new
  end

  def create
    approved_at = Time.new *flatten_datetime_array(params[:pioneer])

    (1..5).each do |i|
      params[:pioneer].delete("approved_at(#{i}i)")
    end

    @pioneer = current_user.pioneers.new(params[:pioneer])
    @pioneer.user_name = current_user.name
    @pioneer.user_email = current_user.email
    @pioneer.approved_at = approved_at
    if @pioneer.save
      redirect_to(pioneers_path,
                  :notice => 'Pioneer was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
    @title = t(:edit_pioneer)
    @pioneer = Pioneer.find(params[:id])
  end

  def update
    @pioneer = Pioneer.find(params[:id])
    approved_at = Time.new *flatten_datetime_array(params[:pioneer])
    @pioneer.approved_at = approved_at
    params[:pioneer][:approved_at] = approved_at

    (1..5).each do |i|
      params[:pioneer].delete("approved_at(#{i}i)")
    end

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
    @pioneer = Pioneer.find(params[:id])
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

  def vote_down
    Pioneer.vote(:voter_id => current_user.id, :votee_id => params[:id], :value => :down)
    @pioneer = Pioneer.find(params[:id])
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end

  private

  def flatten_datetime_array hash
    %w(1 2 3 4 5).map { |e| hash["approved_at(#{e}i)"].to_i }
  end

end
