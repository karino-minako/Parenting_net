class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @question_new = Question.new
    @answer = Answer.new(answer_params)
    @answer.question_id = @question.id
    @answer.user_id = current_user.id
    @answer_question = @answer.question
    if @answer.save
      flash[:answer] = "回答しました！"
      #通知の作成
      @answer_question.create_notification_answer!(current_user, @answer.id)
    end
    @answers = @question.answers
    render 'create.js.erb' #テストに必要
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.update(answer_params)
      flash[:answer] = "回答を編集しました！"
      redirect_to question_path(@answer.question)
    else
      render 'edit'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @question = @answer.question
    if @answer.user != current_user
      redirect_to request.referer
    end
    @answer.destroy
    flash[:answer] = "回答を削除しました！"
  end

  private

  def answer_params
    params.require(:answer).permit(:answer)
  end
end
