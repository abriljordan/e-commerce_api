require 'rails_helper'

RSpec.describe Cart, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  # In carts_spec.rb
let(:user) { create(:user) }
let(:product) { create(:product) }
let(:cart) { create(:cart, user: user) }
let!(:cart_item) { create(:cart_item, cart: cart, product: product, user: user, quantity: 2) }

end

