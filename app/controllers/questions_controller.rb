class QuestionsController < ApplicationController
  before_action :authenticate_user!

  def new
  	@question = Question.new
    @tags = Question.tag_counts_on(:tags).order('count DESC')
    @question_empathy_ranks = Question.create_question_empathy_ranking
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
    @answers =
    if params[:likes_order]
      Answer.answer_like_ranks(@question.id)
    else
      @question.answers
    end
    @answer = Answer.new
    @tags = Question.tag_counts_on(:tags).order('count DESC')
    @question_empathy_ranks = Question.create_question_empathy_ranking
  end

  def edit
  	@question = Question.find(params[:id])
    @tags = Question.tag_counts_on(:tags).order('count DESC')
    @question_empathy_ranks = Question.create_question_empathy_ranking
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
  	params.require(:question).permit(:title, :body, :image, :tag_list)
  end
end
