class EmpathiesController < ApplicationController
  def create
  	@question = Question.find(params[:question_id])
  	empathy = @question.empathies.new(user_id: current_user.id)
  	empathy.save
  	redirect_to request.referer
  end

  def destroy
  	@question = Question.find(params[:question_id])
  	empathy = current_user.empathies.find_by(question_id: @question.id)
  	empathy.destroy
  	redirect_to request.referer
  end

  private
  def redirect
  	case params[:redirect_id].to_i
  	when 0
  		redirect_to questions_path
  	when 1
  		redirect_to question_path(@question)
  	end
  end
end
