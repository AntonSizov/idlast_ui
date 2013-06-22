class PioneersController < ApplicationController

  load_and_authorize_resource

  def index
    @title = t(:my_pioneers)
    @pioneers = current_user.pioneers.approved_sorted_by_img_id.paginate(page: params[:page], per_page: 10)
    @pendings = current_user.pioneers.pending
  end

  def statistics
    @title = t(:statistics)
  end

  def vectors
    @title = t(:vectors)
    @pioneers = Pioneer.approved_vectors_sorted_by_img_id.paginate(page: params[:page], per_page: 10)
  end

  def illustrations
    @title = t(:illustrations)
    @pioneers = Pioneer.approved_illustrations_sorted_by_img_id.paginate(page: params[:page], per_page: 10)
  end

  def photos
    @title = t(:photos)
    @pioneers = Pioneer.approved_photos_sorted_by_img_id.paginate(page: params[:page], per_page: 10)
  end

  def new
    @title = t(:new_pioneer)
    @pioneer = current_user.pioneers.new
  end

  def create
    @pioneer = current_user.pioneers.new(params[:pioneer])
    @pioneer.user_name = current_user.name
    @pioneer.user_email = current_user.email
    if @pioneer.save
      redirect_to(pioneers_path, notice: t(:pioneer_created_msg))
    else
      render action: "new"
    end
  end

  def edit
    @title = t(:edit_pioneer)
    @pioneer = Pioneer.find(params[:id])
  end

  def update
    @pioneer = Pioneer.find(params[:id])

    if @pioneer.update_attributes(params[:pioneer])
      redirect_to(pioneers_path, notice: t(:pioneer_updated_msg))
    else
      render action: "edit"
    end
  end

  def destroy
    @pioneer = Pioneer.find(params[:id])
    @pioneer.destroy
    redirect_to(pioneers_url)
  end

  def vote_up
    @pioneer = Pioneer.find(params[:id])
    @pioneer.vote(voter: current_user, value: :up) if @pioneer.voteble?
    respond_to do |format|
      format.js
    end
  end

  def vote_down
    @pioneer = Pioneer.find(params[:id])
    @pioneer.vote(voter: current_user, value: :down) if @pioneer.voteble?
    respond_to do |format|
      format.js
    end
  end

end
