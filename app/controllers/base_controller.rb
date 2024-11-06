# app/controllers/base_controller.rb
class BaseController < ApplicationController
    before_action :authorize_request
  
    private
  
    def authorize_request
        header = request.headers['Authorization']
        token = header.split(' ').last if header
        begin
          decoded = JsonWebToken.decode(token)
          @current_user = User.find(decoded[:user_id])
        rescue => e
          render json: { message: 'Invalid token', error: e.message }, status: :unauthorized
        end
      end
  end