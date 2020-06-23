class CommentLikesController < ApplicationController
	def create
  	@comment = Comment.find(params[:id])
  	comment_like = @comment.comment_likes.new(user_id: current_user.id)
  	comment_like.save
  	redirect_to request.referer
  end

  def destroy
  	@comment = Comment.find(params[:id])
  	comment_like = current_user.comment_likes.find_by(comment_id: @comment.id)
  	comment_like.destroy
  	redirect_to request.referer
  end

  private
  def redirect
  	case params[:redirect_id].to_i
  	when 0
  		redirect_to posts_path
  	when 1
  		redirect_to post_path(@comment.post)
  	end
  end
end
