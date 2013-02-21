 class ArticlesController < ApplicationController

  def index
    @title = "Blog"
    @articles = Article.where(:published => true).order_by(created_at: -1).paginate(:page => params[:page], :per_page => 5)
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @title = "New article"
    @article = Article.new
  end

  def edit
    @title = 'Edit article'
    @article = Article.find(params[:id])
  end

  def create
    @article = current_user.articles.new(params[:article])
    @article.user_name = current_user.name
    if @article.save
      redirect_to(articles_url,
                  :notice => 'Article was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      redirect_to(@article, :notice => 'Article was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to(articles_url)
  end

end
