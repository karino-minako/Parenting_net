class Answer < ApplicationRecord
	belongs_to :user
	belongs_to :question
	validates :answer, presence: true
	has_many :answer_likes, dependent: :destroy
	def answer_liked_by?(user)
		answer_likes.where(user_id: user.id).exists?
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
	# 解答をいいね順に並べるメソッド
	def self.answer_like_ranks(question_id)
		answers = Question.find(question_id).answers.map { |answer| [answer.id, answer.answer_likes.count] }.to_h.sort_by{|_, v| -v}
		answers.map do |answer|
			Answer.find(answer.first)
		end
	end
end
