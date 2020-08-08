class EmpathiesController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    unless @question.empathized_by?(current_user)
      empathy = @question.empathies.new(user_id: current_user.id)
      empathy.save
      @question = Question.find(params[:question_id])
      #通知の作成
      @question.create_notification_by(current_user)
      respond_to do |format|
        format.html {redirect_to request.referrer}
        format.js
      end
    end
  end

  def destroy
    @question = Question.find(params[:question_id])
    empathy = current_user.empathies.find_by(question_id: @question.id)
    empathy.destroy
  end
end