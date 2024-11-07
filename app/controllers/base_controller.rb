# app/controllers/base_controller.rb
class BaseController < ActionController::API
  before_action :authorize_request

  attr_reader :current_user  # Make current_user accessible

  private

  def authorize_request
    header = request.headers['Authorization']
    if header.blank?
      return render json: { errors: 'Authorization header missing' }, status: :unauthorized
    end

    token = header.split(' ').last
    decoded = JsonWebToken.decode(token)
    @current_user = User.find(decoded[:user_id]) if decoded.present?

  rescue ActiveRecord::RecordNotFound => e
    render json: { errors: e.message }, status: :unauthorized
  rescue JWT::DecodeError => e
    render json: { errors: 'Invalid token' }, status: :unauthorized
  end
end