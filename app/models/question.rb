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
end
