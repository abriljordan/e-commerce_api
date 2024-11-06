class Product < ApplicationRecord
    has_many :cart_items
    has_many :carts, through: :cart_items  # Product can be in multiple carts

    validates :price, numericality: { greater_than_or_equal_to: 0 }
    validates :inventory, numericality: { greater_than_or_equal_to: 0 }
  end