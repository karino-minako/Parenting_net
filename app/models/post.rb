class Post < ApplicationRecord
  belongs_to :user
  attachment :image
  validates :title, presence: true, length: {maximum: 20}
  validates :body, presence: true, length: {maximum: 200}
  has_many :comments, dependent: :destroy
  has_many :post_likes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def post_liked_by?(user)
    post_likes.where(user_id: user.id).exists?
  end

  # 投稿ランキング(いいね順)を作るメソッド(3位まで)
  def self.create_post_like_ranks
    Post.find(PostLike.group(:post_id).order('count(post_id) desc').limit(3).pluck(:post_id))
  end

  # 投稿ランキング(いいね順)を作るメソッド
  def self.create_post_like_ranking
    Post.find(PostLike.group(:post_id).order('count(post_id) desc').limit(5).pluck(:post_id))
  end

  #タグ付けに必要
  acts_as_taggable

  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      item_id: id,
      visited_id: user_id,
      action: "like"
    )
    notification.save if notification.valid?
  end

  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
end