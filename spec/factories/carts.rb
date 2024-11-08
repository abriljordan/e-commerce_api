# spec/factories/carts.rb
FactoryBot.define do
  factory :cart do
    user { association :user } # Associates a user with the cart
  end
end