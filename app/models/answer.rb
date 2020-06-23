class Answer < ApplicationRecord
	belongs_to :user
	belongs_to :question
	validates :answer, presence: true
	has_many :answer_likes, dependent: :destroy
	def answer_liked_by?(user)
		answer_likes.where(user_id: user.id).exists?
	end
end
