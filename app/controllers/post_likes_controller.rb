class PostLikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    unless @post.post_liked_by?(current_user)
      post_like = @post.post_likes.new(user_id: current_user.id)
      post_like.save
      @post_user_url = "https://#{ENV['AWS_S3_BUCKET_NAME']}.s3-#{ENV['AWS_REGION']}.amazonaws.com/store/" + @post.user.profile_image_id.to_s
      @image_url = "https://#{ENV['AWS_S3_BUCKET_NAME']}.s3-#{ENV['AWS_REGION']}.amazonaws.com/store/"
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    post_like = current_user.post_likes.find_by(post_id: @post.id)
    post_like.destroy
    @post_user_url = "https://#{ENV['AWS_S3_BUCKET_NAME']}.s3-#{ENV['AWS_REGION']}.amazonaws.com/store/" + @post.user.profile_image_id.to_s
    @image_url = "https://#{ENV['AWS_S3_BUCKET_NAME']}.s3-#{ENV['AWS_REGION']}.amazonaws.com/store/"
  end
end