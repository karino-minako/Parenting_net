class HomeController < ApplicationController
  def top
  	@post_like_ranks = Post.create_post_like_ranks
  	@question_empathies_ranks = Question.create_question_empathy_ranks
  end

  def about
  end
end
