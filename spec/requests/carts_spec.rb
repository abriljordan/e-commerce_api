# spec/requests/carts_spec.rb
require 'rails_helper'

RSpec.describe 'Carts', type: :request do
  let!(:user) { create(:user) }
  let!(:product) { create(:product) }
  let!(:cart) { create(:cart, user: user) }
  let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 2) }

  describe 'GET /cart' do
    context 'when the user has a cart' do
      before { get '/cart', headers: { 'Authorization' => "Bearer #{user.auth_token}" } }

      it 'returns the cart items' do
        expect(response).to have_http_status(:success)
        expect(json).not_to be_empty
        expect(json.size).to eq(1)  # Should return 1 item in the cart
        expect(json[0]['product']['name']).to eq(product.name)
        expect(json[0]['quantity']).to eq(2)
      end
    end

    context 'when the user has no cart' do
      before { get '/cart', headers: { 'Authorization' => "Bearer #{user.auth_token}" } }

      it 'returns an error message' do
        cart.destroy  # Remove the cart for the user
        expect(response).to have_http_status(:not_found)
        expect(json['error']).to eq('Cart not found')
      end
    end
  end
end