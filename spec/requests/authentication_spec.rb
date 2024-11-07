# spec/requests/authentication_spec.rb
require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  describe 'POST /login' do
    let(:user) { create(:user, email: 'user@example.com', password: 'password') }
    
    context 'with valid credentials' do
      before do
        post '/login', params: { email: user.email, password: 'password' }
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid credentials' do
      before do
        post '/login', params: { email: user.email, password: 'incorrect_password' }
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end