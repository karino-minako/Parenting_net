class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @post_new = Post.new
    @comment = Comment.new(comment_params)
    @comment.post_id = @post.id
    @comment.user_id = current_user.id
    @comment_post = @comment.post
    if @comment.save
      flash[:comment] = "< コメントしました！ >"
      #通知の作成
      @comment_post.create_notification_comment!(current_user, @comment.id)
    end
    @comments = @post.comments
    render 'create.js.erb'
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      flash[:comment] = "< コメントを編集しました！ >"
      redirect_to post_path(@comment.post)
    else
      render 'edit'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    if @comment.user != current_user
      redirect_to request.referer
    end
    @comment.destroy
    flash[:comment] = "< コメントを削除しました！ >"
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

end