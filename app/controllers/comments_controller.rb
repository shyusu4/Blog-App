class CommentsController < ApplicationController
  load_and_authorize_resource

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(post_id: params[:id], author: current_user, text: params[:text])
    if @comment.save
      redirect_to user_post_path(current_user.id, params[:id])
    else
      render :new, alert: 'Error: Comment not saved.'
    end
  end

  def destroy
    @comment = Comment.find(params[:comment_id])
    @comment.destroy
    redirect_to user_post_path(params[:author_id], params[:id])
  end
end
