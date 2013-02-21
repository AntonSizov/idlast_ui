class CommentsController < ApplicationController

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new(params[:comment])
    @comment.set_user(current_user)
    if @comment.save
      redirect_to @article, :notice => 'Comment created!'
    else
      redirect_to @article, :error => 'Comment was not created'
    end
  end

  def destroy
    @article = Article.find(params[:article_id])
    @article.comments.find(params[:id]).destroy
    redirect_to @article, :notice => 'Comment deleted'
  end

end
