class AnswerLikesController < ApplicationController
  def create
    @answer = Answer.find(params[:id])
    answer_like = @answer.answer_likes.new(user_id: current_user.id)
    answer_like.save
  end

  def destroy
    @answer = Answer.find(params[:id])
    answer_like = current_user.answer_likes.find_by(answer_id: @answer.id)
    answer_like.destroy
  end
end
