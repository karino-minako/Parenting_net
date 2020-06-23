class QuestionsController < ApplicationController
  before_action :authenticate_user!

  def new
  	@question = Question.new
  end

  def create
  	@question = Question.new(question_params)
  	@question.user_id = current_user.id
  	if @question.save
  	  flash[:notice] = "質問しました！"
  	  redirect_to question_path(@question)
  	else
  	  render action: :new
  	end
  end

  def index
  	@questions = Question.all
  end

  def show
  	@question = Question.find(params[:id])
    @answer = Answer.new
    @answers = @question.answers
  end

  def edit
  	@question = Question.find(params[:id])
  end

  def update
  	@question = Question.find(params[:id])
  	if @question.update(question_params)
  	  flash[:notice] = "投稿を更新しました！"
  	  redirect_to question_path(@question)
  	else
  	  render :show
  	end
  end

  def destroy
  	question = Question.find(params[:id])
  	question.destroy
  	flash[:notice] = "投稿を削除しました！"
  	redirect_to questions_path
  end

  private
  def question_params
  	params.require(:question).permit(:title, :body, :image)
  end
end
