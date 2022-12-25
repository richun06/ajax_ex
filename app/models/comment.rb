class Comment < ApplicationRecord
  belongs_to :blog
  validates :content, presence: true
  belongs_to :user
end
