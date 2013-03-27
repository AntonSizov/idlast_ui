 class ArticlesController < ApplicationController

  def index
    @title = "Blog"
    @articles = Article.where(:published => true).order_by(created_at: -1).paginate(:page => params[:page], :per_page => 5)
  end

  def show
    @article = Article.find(params[:id])
    @title = @article.title
  end

end
