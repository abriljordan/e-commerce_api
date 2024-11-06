class AuthenticationController < ApplicationController

  require_relative '../lib/json_web_token'
# require_relative '../../lib/json_web_token'

  def signup
    user = User.new(user_params)  # Define the 'user' variable
    
    if user.save
      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private
  
  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end
end