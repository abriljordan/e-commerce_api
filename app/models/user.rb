class User < ApplicationRecord
  has_secure_password

  enum role: { user: 0, admin: 1 } # Keep using the hash format for Rails 7.x

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_one :cart, dependent: :destroy # Single cart per user, auto-deletes if user is removed
  has_many :cart_items, through: :cart
  has_many :products, through: :cart_items

  def generate_auth_token
    JsonWebToken.encode({ user_id: id }) # Assuming you want to encode the user ID
  end
  
end
