require 'rails_helper'

RSpec.describe 'Routing', type: :routing do
  it 'routes GET /cart to carts#index' do
    expect(get: '/cart').to route_to(controller: 'carts', action: 'index')
  end

  it 'routes POST /checkout to carts#checkout' do
    expect(post: '/checkout').to route_to(controller: 'carts', action: 'checkout')
  end
end