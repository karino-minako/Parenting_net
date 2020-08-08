class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  validates :answer, presence: true, length: {maximum: 200}
  has_many :answer_likes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def answer_liked_by?(user)
    answer_likes.where(user_id: user.id).exists?
  end

  # コメントをいいね順に並べるメソッド
  def self.answer_like_ranks(question_id)
    question = Question.find(question_id)
    question.answers.joins(:answer_likes).group(:answer_id).order('count(answer_likes.answer_id) desc')
  end
end
