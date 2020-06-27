class Comment < ApplicationRecord
	belongs_to :user
	belongs_to :post
  validates :comment, presence: true
  has_many :comment_likes, dependent: :destroy
  def comment_liked_by?(user)
		comment_likes.where(user_id: user.id).exists?
	end

  # コメントをいいね順に並べるメソッド
	def self.comment_like_ranks(post_id)
		# comments は comment_id と like_count の配列です
		# ex: comments = [[1, 3],[4, 2],[5, 1]...[56, 0]]
		comments = Post.find(post_id).comments.map { |comment| [comment.id, comment.comment_likes.count] }.to_h.sort_by{|_, v| -v}
	  comments.map do |comment|
	  	# 1st: Comment.find(1)
	  	# 2nd: Comment.find(4)
	  	# 3rd: Comment.find(5)
	  	# :
	  	# :
	  	# nth: Comment.find(56)
	  	Comment.find(comment.first)
	  end
	end
end
