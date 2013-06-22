 class ArticlesController < ApplicationController

  def index
    @title = t(:blog_h)
    @articles = Article.published_sorted_by_created_at.paginate(page: params[:page], per_page: 5)
  end

  def show
    @article = Article.find(params[:id])
    @title = @article.title
  end

end
