class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
  	@question = Question.find(params[:question_id])
  	@question_new = Question.new
  	@answer = @question.answers.new(answer_params)
  	@answer.user_id = current_user.id
  	if @answer.save
  	  flash[:notice] = "コメントしました！"
  	  redirect_to question_path(@question)
  	else
  	  @answers = Answer.where(question_id: @question.id)
  	  render '/questions/show'
  	end
  end

  def edit
  	@answer = Answer.find(params[:question_id])
  end

  def update
  	@answer = Answer.find(params[:question_id])
  	if @answer.update(answer_params)
  	  redirect_to question_path(@answer.question)
  	else
  	  render 'edit'
  	end
  end

  def destroy
  	@answer = Answer.find(params[:question_id])
  	if @answer.user != current_user
  	  redirect_to request.referer
  	end
  	@answer.destroy
  	redirect_to request.referer
  end

  private

  def answer_params
  	params.require(:answer).permit(:answer)
  end
end
