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

    context 'when the user is not authenticated' do
      before do
        get '/products' # No authorization header
      end
  
      it 'returns an unauthorized error' do
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key('errors') # Check if the key exists
        expect(json_response['errors']).to eq('Authorization header missing') # Adjusted to match the actual response
      end
    end

    context 'when there are no products' do
      before do
        # Ensure the database is clean before this test runs
        Product.delete_all # Clear any existing products
        token = JsonWebToken.encode(user_id: admin_user.id)
        get '/products', headers: { 'Authorization' => "Bearer #{token}" }
      end
  
      it 'returns an empty list' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['products']).to be_empty
      end
    end
  end


  describe 'POST /products' do
    context 'when an admin user tries to create a product' do
      before do
        token = JsonWebToken.encode(user_id: admin_user.id)
        post '/products', params: { product: { name: 'New Admin Product', price: 200, inventory: 10 } },
                          headers: { 'Authorization' => "Bearer #{token}" }
        @json_response = JSON.parse(response.body) # Parse response for assertions
      end
  
      it 'creates the product successfully' do
        expect(response).to have_http_status(:created)
        expect(@json_response['product']['name']).to eq('New Admin Product')
      end
    end
  
    context 'when an admin user tries to create a product without required parameters' do
      before do
        token = JsonWebToken.encode(user_id: admin_user.id)
        post '/products', params: { product: { name: nil, price: nil } }, # Missing required parameters
                          headers: { 'Authorization' => "Bearer #{token}" }
        @json_response = JSON.parse(response.body) # Parse response for assertions
      end
  
      it 'returns an error message' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(@json_response['errors']).to include("Name can't be blank")
        expect(@json_response['errors']).to include("Price is not a number") # Adjusted
        expect(@json_response['errors']).to include("Inventory can't be blank")
        expect(@json_response['errors']).to include("Inventory is not a number")
      end
    end

    context 'when a non-admin user tries to create a product' do
      let(:non_admin_user) { create(:user) } # Non-admin user
  
      before do
        token = JsonWebToken.encode(user_id: non_admin_user.id)
        post '/products', params: { product: { name: 'New Product', price: 100, inventory: 10 } },
                          headers: { 'Authorization' => "Bearer #{token}" }
      end
  
      it 'prevents non-admin from creating a product' do
        expect(response).to have_http_status(:forbidden) # 403 Forbidden
      end
    end
  
    context 'when an admin user tries to create a product with invalid parameters' do
      before do
        token = JsonWebToken.encode(user_id: admin_user.id)
        post '/products', params: { product: { name: '', price: -10, inventory: nil } }, # Invalid parameters
                          headers: { 'Authorization' => "Bearer #{token}" }
        @json_response = JSON.parse(response.body) # Parse the response for assertions
      end
  
      it 'returns an error message' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(@json_response['errors']).to include("Name can't be blank")
        expect(@json_response['errors']).to include("Price must be greater than or equal to 0")
        expect(@json_response['errors']).to include("Inventory can't be blank")
        expect(@json_response['errors']).to include("Inventory is not a number")
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

      context 'when trying to update a non-existent product' do
        before do
          token = JsonWebToken.encode(user_id: admin_user.id)
          patch '/products/99999', params: { product: { name: 'Updated Name' } },
                                    headers: { 'Authorization' => "Bearer #{token}" }
        end
    
        it 'returns a not found error' do
          expect(response).to have_http_status(:not_found)
          json_response = JSON.parse(response.body)
          expect(json_response['error']).to eq('Product not found')
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