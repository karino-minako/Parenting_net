class CommentLikesController < ApplicationController
  def create
    @comment = Comment.find(params[:id])
    comment_like = @comment.comment_likes.new(user_id: current_user.id)
    comment_like.save
  end

  def destroy
    @comment = Comment.find(params[:id])
    comment_like = current_user.comment_likes.find_by(comment_id: @comment.id)
    comment_like.destroy
  end
end
