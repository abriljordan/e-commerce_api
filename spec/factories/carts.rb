# spec/factories/carts.rb
FactoryBot.define do
    factory :cart do
      association :user
    end
  end