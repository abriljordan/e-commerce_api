# spec/support/auth_helpers.rb
module AuthHelpers
    def generate_token(user)
      JsonWebToken.encode(user_id: user.id)
    end
  
    def admin_token(admin)
      generate_token(admin)
    end
  end