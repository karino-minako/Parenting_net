class PostLikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    unless @post.post_liked_by?(current_user)
      post_like = @post.post_likes.new(user_id: current_user.id)
      post_like.save
      @post = Post.find(params[:post_id])
      #通知の作成
      @post.create_notification_by(current_user)
      respond_to do |format|
        format.html {redirect_to request.referrer}
        format.js
      end
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    post_like = current_user.post_likes.find_by(post_id: @post.id)
    post_like.destroy
  end
end