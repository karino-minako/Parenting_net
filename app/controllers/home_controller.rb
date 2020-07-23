class HomeController < ApplicationController

  # 投稿,質問ランキング(3位まで),モデルに定義
  def top
    @post_like_ranks = Post.create_post_like_ranks
    @question_empathies_ranks = Question.create_question_empathy_ranks
    @image_url = "https://#{ENV['AWS_S3_BUCKET_NAME']}.s3-#{ENV['AWS_REGION']}.amazonaws.com/store/"
  end

  def about
  end
end
