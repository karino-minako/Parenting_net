class Question < ApplicationRecord
  belongs_to :user
  attachment :image
  validates :title, presence: true, length: {maximum: 20}
  validates :body, presence: true, length: {maximum: 200}
  has_many :answers, dependent: :destroy
  has_many :empathies, dependent: :destroy
  has_many :notifications, dependent: :destroy

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

  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      question_id: id,
      visited_id: user_id,
      action: "empathy"
    )
    # 自分の質問に対するいいねの場合は、通知済みとする
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  def create_notification_answer!(current_user, answer_id)
    # 自分以外に回答している人をすべて取得し、全員に通知を送る
    temp_ids = Answer.select(:user_id).where(question_id: id).where.not(user_id: current_user.id).distinct.pluck(:user_id)
    # temp_idsの配列にこの質問のuser_idを入れる
    temp_ids << user_id
    # uniqで回答した人と質問者が同じ場合に重複を取り除く
    temp_ids.uniq.each do |temp_id|
      save_notification_answer!(current_user, answer_id, temp_id)
    end
  end

  def save_notification_answer!(current_user, answer_id, visited_id)
    # 回答は複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      question_id: id,
      answer_id: answer_id,
      visited_id: visited_id,
      action: 'answer'
    )
    # 自分の質問に対する回答の場合は、通知済みとする
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

end