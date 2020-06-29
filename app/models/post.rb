class Post < ApplicationRecord
	belongs_to :user
	attachment :image
	validates :title, presence: true, length: {maximum: 20}
	validates :body, presence: true, length: {maximum: 200}
	has_many :comments, dependent: :destroy
	has_many :post_likes, dependent: :destroy
	def post_liked_by?(user)
		post_likes.where(user_id: user.id).exists?
	end

  def self.create_post_like_ranks
    Post.find(PostLike.group(:post_id).order('count(post_id) desc').limit(3).pluck(:post_id))
  end

  def self.create_post_like_all_ranks
  	Post.find(PostLike.group(:post_id).order('count(post_id) desc').pluck(:post_id))
  end

  acts_as_taggable
end
