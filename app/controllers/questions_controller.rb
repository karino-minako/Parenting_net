class QuestionsController < ApplicationController
  before_action :authenticate_user!

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id
    if @question.save
      redirect_to question_path(@question)
    else
      render action: :new
    end
  end

  def index
    if params[:tag_name]
      @questions = Question.tagged_with("#{params[:tag_name]}").page(params[:page]).reverse_order
    else
      @questions = Question.page(params[:page]).reverse_order
    end
    @tags = Question.tag_counts_on(:tags).order('count DESC')
    @question_empathy_ranks = Question.create_question_empathy_ranking
  end

  def show
    @question = Question.find(params[:id])
    @answers = params[:likes_order].present? ? Answer.answer_like_ranks(@question.id) : @question.answers
    @answer = Answer.new
    @tags = Question.tag_counts_on(:tags).order('count DESC')
    @question_empathy_ranks = Question.create_question_empathy_ranking
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      sleep(3) # S3への画像反映のタイムラグを考慮して3秒待機
      redirect_to question_path(@question)
    else
      render :edit
    end
  end

  def destroy
    question = Question.find(params[:id])
    question.destroy
    flash[:notice] = "質問を削除しました！"
    redirect_to questions_path
  end

  private
  def question_params
    params.require(:question).permit(:title, :body, :image, :tag_list)
  end
end
