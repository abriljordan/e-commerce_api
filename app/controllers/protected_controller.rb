class ProtectedController < ApplicationController
    before_action :authorize_request
  
    def show
      render json: { message: "This is a protected endpoint." }
    end
  
    private
  
    def authorize_request
      header = request.headers['Authorization']
      token = header.split(' ').last if header
      decoded = JsonWebToken.decode(token)
      @current_user = User.find(decoded[:user_id]) if decoded
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { errors: 'Unauthorized' }, status: :unauthorized
    end
  end