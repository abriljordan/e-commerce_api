# spec/requests/products_spec.rb
require 'rails_helper'

RSpec.describe "Products", type: :request do
  let!(:product) { create(:product) }

  describe 'GET /products' do
    it 'returns a list of products' do
      get '/products'
      expect(response).to have_http_status(:ok)
      expect(response_body.size).to eq(1)
    end
  end

  describe 'POST /products' do
    let(:admin) { create(:user, role: :admin) }

    it 'allows admin to create a product' do
      post '/products', params: { name: 'New Product', price: 50.0, inventory: 20 }, headers: { 'Authorization' => "Bearer #{admin_token(admin)}" }
      expect(response).to have_http_status(:created)
    end

    it 'prevents non-admin from creating a product' do
      post '/products', params: { name: 'New Product', price: 50.0, inventory: 20 }
      expect(response).to have_http_status(:forbidden)
    end
  end
end