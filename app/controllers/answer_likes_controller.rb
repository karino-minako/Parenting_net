class AnswerLikesController < ApplicationController
	def create
  	@answer = Answer.find(params[:id])
  	answer_like = @answer.answer_likes.new(user_id: current_user.id)
  	answer_like.save
  	redirect_to request.referer
  end

  def destroy
  	@answer = Answer.find(params[:id])
  	answer_like = current_user.answer_likes.find_by(answer_id: @answer.id)
  	answer_like.destroy
  	redirect_to request.referer
  end

  private
  def redirect
  	case params[:redirect_id].to_i
  	when 0
  		redirect_to questions_path
  	when 1
  		redirect_to question_path(@answer.question)
  	end
  end
end
