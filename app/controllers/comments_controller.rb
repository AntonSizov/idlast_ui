class CommentsController < ApplicationController

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new(params[:comment])
    @comment.set_user(current_user)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to(@article, :notice => 'Comment created') }
        format.js
      else
        format.html { redirect_to(@article, :error => 'Comment was not created') }
        format.js
      end
    end
  end

  def destroy
    @article = Article.find(params[:article_id])
    @article.comments.find(params[:id]).destroy
    redirect_to @article, :notice => 'Comment deleted'
  end

end
