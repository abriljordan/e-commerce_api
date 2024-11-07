require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let(:user) { create(:user, email: 'user@example.com', password: 'password') }

  describe 'POST /login' do
    context 'with valid credentials' do
      before { post '/login', params: { email: user.email, password: 'password' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid credentials' do
      before { post '/login', params: { email: user.email, password: 'wrongpassword' } }

      it 'returns status code 401' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end