class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: {maximum: 80}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  # dependent destroy means todos are removed on a user destroy(delete)
  has_many :todos, dependent: :destroy
  has_secure_password
  validates :password, presence: true, length: {minimum: 5}, allow_nil: true
end