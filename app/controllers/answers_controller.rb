class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
  	@question = Question.find(params[:question_id])
  	@question_new = Question.new
  	@answer = Answer.new(answer_params)
    @answer.question_id = @question.id
    @answer.user_id = current_user.id
  	if @answer.save
  	  flash.now[:notice] = "解答しました！"
  	end
    @answers = Answer.where(question_id: @question).order(created_at: :desc) #降順
  end

  def edit
  	@answer = Answer.find(params[:question_id])
  end

  def update
  	@answer = Answer.find(params[:question_id])
  	if @answer.update(answer_params)
      flash[:notice] = "解答を更新しました！"
  	  redirect_to question_path(@answer.question)
  	else
  	  render 'edit'
  	end
  end

  def destroy
  	@answer = Answer.find(params[:question_id])
    @question = @answer.question
  	if @answer.user != current_user
  	  redirect_to request.referer
  	end
  	@answer.destroy
    flash.now[:notice] = "解答を削除しました！"
  end

  def answer_like_ranks
    @question = Question.find(params[:question_id])
    @answers = Answer.answer_like_ranks(@question.id)
  end

  private

  def answer_params
  	params.require(:answer).permit(:answer)
  end
end
