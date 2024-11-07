# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { 'user@example.com' }
    password { 'password' }
    password_confirmation { 'password' }

    trait :admin do
      role { :admin } # Adjust according to your role implementation (enum or string)
    end
  end
end