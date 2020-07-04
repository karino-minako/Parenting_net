class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.page(params[:page]).reverse_order
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).reverse_order
    @questions = @user.questions.page(params[:page]).reverse_order
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "会員情報を更新しました！"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  private
  def user_params
  	params.require(:user).permit(:name, :introduction, :profile_image, :email)
  end
end
