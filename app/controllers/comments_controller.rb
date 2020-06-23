class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
  	@post = Post.find(params[:post_id])
  	@post_new = Post.new
  	@comment = @post.comments.new(comment_params)
  	@comment.user_id = current_user.id
  	if @comment.save
  	  flash[:notice] = "コメントしました！"
  	  redirect_to post_path(@post)
  	else
  	  @comments = Comment.where(post_id: @post.id)
  	  render '/posts/show'
  	end
  end

  def edit
  	@comment = Comment.find(params[:post_id])
    @post = @comment.post
  end

  def update
  	@comment = Comment.find(params[:post_id])
  	if @comment.update(comment_params)
  	  redirect_to post_path(@comment.post)
  	else
  	  render 'edit'
  	end
  end

  def destroy
  	@comment = Comment.find(params[:post_id])
  	if @comment.user != current_user
  	  redirect_to request.referer
  	end
  	@comment.destroy
  	redirect_to request.referer
  end

  private

  def comment_params
  	params.require(:comment).permit(:comment)
  end

end
