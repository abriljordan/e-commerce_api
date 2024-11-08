require 'rails_helper'

RSpec.describe Cart, type: :model do
  let!(:user) { create(:user) }
  let!(:cart) { create(:cart, user: user) }
  let!(:product) { create(:product) }
  let!(:cart_item) { create(:cart_item, cart: cart, product: product) }

  # Test associations
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:cart_items).dependent(:destroy) }
    it { should have_many(:products).through(:cart_items) }
  end

  # Test validations
  describe 'validations' do
    it { should validate_presence_of(:user) }
  end

  # Custom method examples
  describe '#total_price' do
    it 'calculates the total price of all cart items' do
      # Assuming you have a `price` attribute on Product and a `quantity` attribute on CartItem
      product.update(price: 10.0)
      cart_item.update(quantity: 2)

      expect(cart.total_price).to eq(20.0) # 10 * 2 = 20
    end
  end

  describe '#add_product' do
    it 'adds a product to the cart' do
      new_product = create(:product)
      cart.add_product(new_product.id)

      expect(cart.products).to include(new_product)
    end
  end
end