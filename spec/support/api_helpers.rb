# spec/support/api_helpers.rb
module ApiHelpers
    def auth_headers(user)
      token = JsonWebToken.encode(user_id: user.id)
      { "Authorization" => "Bearer #{token}" }
    end
  end