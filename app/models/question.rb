class Question < ApplicationRecord
  belongs_to :user
  attachment :image
  validates :title, presence: true, length: {maximum: 20}
  validates :body, presence: true, length: {maximum: 200}
  has_many :answers, dependent: :destroy
  has_many :empathies, dependent: :destroy

  def empathized_by?(user)
    empathies.where(user_id: user.id).exists?
  end

  # 質問ランキング(共感した順)を作るメソッド(3位まで)
  def self.create_question_empathy_ranks
    Question.find(Empathy.group(:question_id).order('count(question_id) desc').limit(3).pluck(:question_id))
  end

  # 質問ランキング(共感した順)を作るメソッド(5位まで)
  def self.create_question_empathy_ranking
    Question.find(Empathy.group(:question_id).order('count(question_id) desc').limit(5).pluck(:question_id))
  end

  #タグ付けに必要
  acts_as_taggable

end