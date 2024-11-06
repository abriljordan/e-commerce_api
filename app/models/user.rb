class User < ApplicationRecord
  has_secure_password

  enum role: { user: 0, admin: 1 }

  validates :email, presence: true, uniqueness: true
  has_one :cart # Single cart per user, auto-deletes if user is removed
  has_many :cart_items
  has_many :products, through: :cart_items
end