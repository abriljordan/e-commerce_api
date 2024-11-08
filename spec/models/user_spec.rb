require 'rails_helper'

RSpec.describe User, type: :model do
  # Association tests
  it { should have_many(:carts) }
  it { should have_secure_password }

  # Validation tests
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  # Example for custom methods
  describe "#full_name" do
    let(:user) { create(:user, first_name: "John", last_name: "Doe") }

    it "returns the user's full name" do
      expect(user.full_name).to eq("John Doe")
    end
  end
end