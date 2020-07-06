class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @question_new = Question.new
    @answer = Answer.new(answer_params)
    @answer.question_id = @question.id
    @answer.user_id = current_user.id
    if @answer.save
      flash.now[:notice] = "回答しました！"
    end
    @answers = Answer.where(question_id: @question).order(created_at: :desc).page(params[:page])
  end

  def edit
    @answer = Answer.find(params[:question_id])
    @tags = Question.tag_counts_on(:tags).order('count DESC')
    @question_empathy_ranks = Question.create_question_empathy_ranking
  end

  def update
    @answer = Answer.find(params[:question_id])
    if @answer.update(answer_params)
      flash[:notice] = "回答を更新しました！"
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
    flash.now[:notice] = "回答を削除しました！"
  end

  private

  def answer_params
    params.require(:answer).permit(:answer)
  end
end
