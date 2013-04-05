class Admin::ArticlesController < Admin::AdminController

  def index
    @title = "Blog"
    @articles = Article.order_by(created_at: -1).paginate(:page => params[:page], :per_page => 5)
    authorize! :index, @articles
  end

  def show
    @article = Article.find(params[:id])
    @title = @article.title
    authorize! :show, @article
  end

  def new
    @title = "New article"
    @article = Article.new
    authorize! :create, @article
  end

  def edit
    @title = 'Edit article'
    @article = Article.find(params[:id])
    authorize! :edit, @article
  end

  def create
    @article = current_user.articles.new(params[:article])
    @article.user_name = current_user.name
    authorize! :create, @article
    if @article.save
      redirect_to(admin_articles_url,
                  :notice => 'Article was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @article = Article.find(params[:id])
    authorize! :edit, @article
    if @article.update_attributes(params[:article])
      redirect_to([:admin, @article], :notice => 'Article was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    authorize! :destroy, @article
    @article.destroy
    redirect_to(admin_articles_url)
  end

end
