FactoryBot.define do
    factory :cart_item do
        association :cart, factory: :cart
        association :product, factory: :product
        quantity { 1 }
    end
end