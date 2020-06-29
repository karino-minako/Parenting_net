class PostsController < ApplicationController
  before_action :authenticate_user!

  def new
  	@post = Post.new
  end

  def create
  	@post = Post.new(post_params)
  	@post.user_id = current_user.id
  	if @post.save
  	  flash[:notice] = "投稿しました！"
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
  end

  def show
  	@post = Post.find(params[:id])
    @comment = Comment.new
  end

  def edit
  	@post = Post.find(params[:id])
  end

  def update
  	@post = Post.find(params[:id])
  	if @post.update(post_params)
  	  flash[:notice] = "投稿を更新しました！"
  	  redirect_to post_path(@post)
  	else
  	  render :show
  	end
  end

  def destroy
  	post = Post.find(params[:id])
  	post.destroy
  	flash[:notice] = "投稿を削除しました！"
  	redirect_to posts_path
  end

  def post_like_ranks
    @like_ranks = Post.create_post_like_all_ranks
  end

  def tag_index
    @tags = Post.tag_counts_on(:tags).order('count DESC')
  end



  private
  def post_params
  	params.require(:post).permit(:title, :body, :image, :tag_list)
  end
end
