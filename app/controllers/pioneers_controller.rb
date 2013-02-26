class PioneersController < ApplicationController

  def index
    @title = "My pioneers"
    # @new_pioneer = current_user.pioneers.new
    @pioneers = current_user.pioneers.paginate(page: params[:page], per_page: 5)
  end

  def vectors
    @title = "Vector pioneers"
    @pioneers = Pioneer.where(approved: true, type: "vector").order_by(img_id: -1).paginate(page: params[:page], per_page: 5)
  end

  def illustrations
    @title = "Illustration pioneers"
    @pioneers = Pioneer.where(approved: true, type: "illustration").order_by(img_id: -1).paginate(page: params[:page], per_page: 5)
  end

  def photos
    @title = "Photo pioneers"
    @pioneers = Pioneer.where(approved: true, type: "photo").order_by(img_id: -1).paginate(page: params[:page], per_page: 5)
  end

  # def show
  #   @menu = :pioneers
  #   @pioneer = Pioneer.find(params[:id])
  #   @title = @article.title
  # end

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

  def flatten_datetime_array hash
    %w(1 2 3 4 5).map { |e| hash["approved_at(#{e}i)"].to_i }
  end

  # def edit
  #   @menu = :blog
  #   @title = 'Edit article'
  #   @article = Article.find(params[:id])
  # end

  # def update
  #   @article = Article.find(params[:id])
  #   if @article.update_attributes(params[:article])
  #     redirect_to(@article, :notice => 'Article was successfully updated.')
  #   else
  #     render :action => "edit"
  #   end
  # end

  # def destroy
  #   @article = Article.find(params[:id])
  #   @article.destroy
  #   redirect_to(articles_url)
  # end

end
