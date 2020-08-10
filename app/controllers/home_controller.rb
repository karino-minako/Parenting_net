class HomeController < ApplicationController

  # 投稿,質問ランキング(3位まで),モデルに定義
  def top
    @post_like_ranks = Post.create_post_like_ranks
    @question_empathies_ranks = Question.create_question_empathy_ranks
  end

  def about
  end

  def new_guest
    user = User.find_or_create_by!(name: 'guest', email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      # user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
    end
    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました！'
  end
end
