class ApplicationController < ActionController::API
  # Add this to authenticate the user for every request
  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    decoded_token = JsonWebToken.decode(token)
    if decoded_token
      @current_user = User.find_by(id: decoded_token[:user_id])
    else
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end

  def authenticate_admin
    authenticate_user
    unless @current_user&.admin?
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end
end