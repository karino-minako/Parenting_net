class PostLikesController < ApplicationController
  def create
  	@post = Post.find(params[:post_id])
  	post_like = @post.post_likes.new(user_id: current_user.id)
  	post_like.save
  	redirect_to request.referer
  end

  def destroy
  	@post = Post.find(params[:post_id])
  	post_like = current_user.post_likes.find_by(post_id: @post.id)
  	post_like.destroy
  	redirect_to request.referer
  end

  private
  def redirect
  	case params[:redirect_id].to_i
  	when 0
  		redirect_to posts_path
  	when 1
  		redirect_to post_path(@post)
  	end
  end
end
