class CommentsController < ApplicationController

  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new(params[:comment])
    @comment.set_user(current_user)

    authorize! :create, @comment

    respond_to do |format|
      if @comment.save
        format.js
      else
        format.js
      end
    end
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])

    authorize! :destroy, @comment

    @comment.destroy

    respond_to do |format|
      format.js
    end

  end

end
