class Todo < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  belongs_to :user
  validates :user_id, presence: true
end