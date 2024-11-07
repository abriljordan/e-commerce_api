require 'rails_helper'

RSpec.describe 'Products', type: :request do
  let(:admin_user) { create(:user, :admin) } # Create an admin user (use factory trait for admin)
  let(:user) { create(:user) } # Regular user without admin privileges
  let!(:product) { create(:product) } # Pre-create a product to test retrieval

  describe 'GET /products' do
    context 'when the user is authenticated' do
      before do
        token = JsonWebToken.encode(user_id: admin_user.id)
        get '/products', headers: { 'Authorization' => "Bearer #{token}" }
      end
  
      it 'returns a list of products' do
        expect(response).to have_http_status(:ok)
  
        # Parse response body to JSON
        json_response = JSON.parse(response.body)
  
        # Check that the response has an array under the 'products' key
        expect(json_response).to have_key('products')
        expect(json_response['products']).to be_an(Array)
        expect(json_response['products'].size).to eq(1) # Adjust if you expect more products
      end
    end
  end

  describe 'POST /products' do
    context 'when a non-admin user tries to create a product' do
      let(:non_admin_user) { create(:user, role: :user) } # Non-admin user
      before do
        token = JsonWebToken.encode(user_id: non_admin_user.id)
        post '/products', params: { product: { name: 'New Product', price: 100, inventory: 10 } }, # Include inventory
                          headers: { 'Authorization' => "Bearer #{token}" }
      end
      
      it 'prevents non-admin from creating a product' do
        expect(response).to have_http_status(:forbidden) # 403 Forbidden
      end
    end

  # Testing the ProductsController Update Action
    describe 'PATCH /products/:id' do
      context 'when an admin user updates a product' do
        let!(:existing_product) { create(:product, name: 'Old Product') }
    
        before do
          token = JsonWebToken.encode(user_id: admin_user.id)
          patch "/products/#{existing_product.id}", params: { product: { name: 'Updated Product', price: 150, inventory: 20 } },
                                                    headers: { 'Authorization' => "Bearer #{token}" }
        end
    
        it 'updates the product' do
          expect(response).to have_http_status(:ok)
          expect(existing_product.reload.name).to eq('Updated Product')
        end
      end
    
      context 'when a non-admin user tries to update a product' do
        let(:non_admin_user) { create(:user) }
        let!(:existing_product) { create(:product) }
    
        before do
          token = JsonWebToken.encode(user_id: non_admin_user.id)
          patch "/products/#{existing_product.id}", params: { product: { name: 'Attempted Update' } },
                                                    headers: { 'Authorization' => "Bearer #{token}" }
        end
    
        it 'prevents non-admin from updating a product' do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    # Testing the ProductsController Destroy Action
    describe 'DELETE /products/:id' do
      context 'when an admin user deletes a product' do
        let!(:product_to_delete) { create(:product) }
    
        before do
          token = JsonWebToken.encode(user_id: admin_user.id)
          delete "/products/#{product_to_delete.id}", headers: { 'Authorization' => "Bearer #{token}" }
        end
    
        it 'deletes the product' do
          expect(response).to have_http_status(:ok)
          expect(Product.exists?(product_to_delete.id)).to be_falsey
        end
      end
    
      context 'when a non-admin user tries to delete a product' do
        let(:non_admin_user) { create(:user) }
        let!(:product_to_delete) { create(:product) }
    
        before do
          token = JsonWebToken.encode(user_id: non_admin_user.id)
          delete "/products/#{product_to_delete.id}", headers: { 'Authorization' => "Bearer #{token}" }
        end
    
        it 'prevents non-admin from deleting a product' do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end


    context 'when an admin user tries to create a product' do
      before do
        token = JsonWebToken.encode(user_id: admin_user.id)
        post '/products', params: { product: { name: 'New Admin Product', price: 200, inventory: 10 } }, # Include inventory
                          headers: { 'Authorization' => "Bearer #{token}" }
        
        # Parse response body to JSON for assertions
        @json_response = JSON.parse(response.body)
      end
      
      it 'allows the admin to create a product' do
        expect(response).to have_http_status(:created)
        expect(@json_response['product']['name']).to eq('New Admin Product') # Access the product key
      end
    end
  end
end