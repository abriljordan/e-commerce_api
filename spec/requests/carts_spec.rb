require 'rails_helper'

RSpec.describe 'Carts', type: :request do
  let!(:user) { create(:user) }
  let!(:cart) { create(:cart, user: user) }
  let!(:product) { create(:product) }
  let(:auth_token) { user.generate_auth_token }

  describe 'GET /cart' do
    context 'when the user has items in the cart' do
      let!(:cart_item) { create(:cart_item, cart: cart, product: product) }

      before do
        get '/cart', headers: { 'Authorization' => "Bearer #{auth_token}" }
      end

      it 'returns the cart items' do
        expect(response).to have_http_status(:ok)
        expect(json['items'].size).to eq(1)
        expect(json['items'].first['product_id']).to eq(product.id)
      end
    end

    context 'when the cart is empty' do
      before do
        get '/cart', headers: { 'Authorization' => "Bearer #{auth_token}" }
      end

      it 'returns an empty cart' do
        expect(response).to have_http_status(:ok)
        expect(json['items']).to be_empty
      end
    end

    context 'when the user is not authenticated' do
      before { get '/cart' } # No Authorization header

      it 'returns a 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to eq('Unauthorized')
      end
    end
  end
end