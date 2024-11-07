class Product < ApplicationRecord
  has_many :cart_items
  has_many :carts, through: :cart_items 

  validates :name, presence: true
  validates :price, presence: true, numericality: true
  validates :inventory, presence: true, numericality: { only_integer: true }  # Ensure inventory is a number
end