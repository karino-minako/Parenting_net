class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :comment, presence: true, length: {maximum: 200}
  has_many :comment_likes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def comment_liked_by?(user)
    comment_likes.where(user_id: user.id).exists?
  end

  # コメントをいいね順に並べるメソッド
  def self.comment_like_ranks(post_id)
    post = Post.find(post_id)
    post.comments.joins(:comment_likes).group(:comment_id).order('count(comment_likes.comment_id) desc')
  end
end
