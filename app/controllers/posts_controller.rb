class PostsController < ApplicationController
  before_action :authenticate_user!

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post)
    else
      render :new
    end
  end

  def index
    if params[:tag_name]
      @posts = Post.tagged_with("#{params[:tag_name]}").page(params[:page]).reverse_order
    else
      @posts = Post.page(params[:page]).reverse_order
    end
    @post_tags = Post.tag_counts_on(:tags).order('count DESC')
    @post_like_ranks = Post.create_post_like_ranking
    @image_url = "https://#{ENV['AWS_S3_BUCKET_NAME']}.s3-#{ENV['AWS_REGION']}.amazonaws.com/store/"
  end

  def show
    @post = Post.find(params[:id])
    @post_url = "https://#{ENV['AWS_S3_BUCKET_NAME']}.s3-#{ENV['AWS_REGION']}.amazonaws.com/store/" + @post.image_id.to_s
    @post_user_url = "https://#{ENV['AWS_S3_BUCKET_NAME']}.s3-#{ENV['AWS_REGION']}.amazonaws.com/store/" + @post.user.profile_image_id.to_s
    @comments = params[:likes_order].present? ? Comment.comment_like_ranks(@post.id) : @post.comments
    @comment = Comment.new
    @image_url = "https://#{ENV['AWS_S3_BUCKET_NAME']}.s3-#{ENV['AWS_REGION']}.amazonaws.com/store/"
    @post_tags = Post.tag_counts_on(:tags).order('count DESC')
    @post_like_ranks = Post.create_post_like_ranking
  end

  def edit
    @post = Post.find(params[:id])
    @post_url = "https://#{ENV['AWS_S3_BUCKET_NAME']}.s3-#{ENV['AWS_REGION']}.amazonaws.com/store/" + @post.image_id.to_s
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      sleep(3) # S3への画像反映のタイムラグを考慮して3秒待機
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    flash[:notice] = "投稿を削除しました！"
    redirect_to posts_path
  end

  private
  def post_params
    params.require(:post).permit(:title, :body, :image, :tag_list)
  end
end
