FactoryBot.define do
    factory :product do
      name { "Sample Product" }
      description { "A great product" }
      price { 100.0 }
      inventory { 10 }
    end
  end
  