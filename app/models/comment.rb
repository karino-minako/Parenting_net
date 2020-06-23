class Comment < ApplicationRecord
	belongs_to :user
	belongs_to :post
  validates :comment, presence: true
  has_many :comment_likes, dependent: :destroy
  def comment_liked_by?(user)
		comment_likes.where(user_id: user.id).exists?
	end
end
