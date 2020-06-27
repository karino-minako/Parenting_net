class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
  	@post = Post.find(params[:post_id])
  	@post_new = Post.new
    @comment = Comment.new(comment_params)
    @comment.post_id = @post.id
  	@comment.user_id = current_user.id
  	if @comment.save
      flash.now[:notice] = "コメントしました！"
  	end
    @comments = Comment.where(post_id: @post).order(created_at: :desc).page(params[:page]) #降順
  end

  def edit
  	@comment = Comment.find(params[:post_id])
    @post = @comment.post
  end

  def update
  	@comment = Comment.find(params[:post_id])
  	if @comment.update(comment_params)
      flash[:notice] = "コメントを更新しました！"
  	  redirect_to post_path(@comment.post)
  	else
  	  render 'edit'
  	end
  end

  def destroy
  	@comment = Comment.find(params[:post_id])
    @post = @comment.post
  	if @comment.user != current_user
      redirect_to request.referer
  	end
  	@comment.destroy
    flash.now[:notice] = "コメントを削除しました！"
  end

  def comment_like_ranks
    @post = Post.find(params[:post_id])
    @comments = Comment.comment_like_ranks(@post.id)
  end

  private

  def comment_params
  	params.require(:comment).permit(:comment)
  end

end
