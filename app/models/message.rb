class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :content, presence: true
  has_many :notifications, dependent: :destroy
end
