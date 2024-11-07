require 'rails_helper'

RSpec.describe 'Carts', type: :request do
  let(:user) { create(:user) }
  let(:product) { create(:product) }

  describe 'GET /cart' do
    context 'when the user has items in the cart' do
      let!(:cart_item) { create(:cart_item, cart: user.cart, product: product) }

      before { get '/cart', headers: { 'Authorization' => "Bearer #{user.auth_token}" } }

      it 'returns the cart items' do
        expect(response).to have_http_status(:ok)
        expect(json['items'].size).to eq(1)
      end
    end

    context 'when the cart is empty' do
      before { get '/cart', headers: { 'Authorization' => "Bearer #{user.auth_token}" } }

      it 'returns an empty cart' do
        expect(response).to have_http_status(:ok)
        expect(json['items']).to be_empty
      end
    end
  end
end