class CartsController < BaseController
  before_action :authorize_request

  # GET /cart
  def index
    cart = @current_user.cart
    if cart
      cart_items = cart.cart_items.includes(:product)
      render json: cart_items.map { |item| { product: item.product, quantity: item.quantity } }
    else
      render json: { error: 'Cart not found' }, status: :not_found
    end
  end

  # POST /carts
  def create
    cart = @current_user.cart || @current_user.create_cart
    quantity = params[:quantity].to_i
    quantity = 1 if quantity < 1  # Ensure quantity is at least 1

    cart_item = CartItem.find_or_initialize_by(cart: cart, product_id: cart_params[:product_id])
    cart_item.quantity = [cart_item.quantity.to_i + quantity, 1].max

    if cart_item.save
      render json: { message: 'Product added to cart', cart_item: cart_item }, status: :created
    else
      render json: { errors: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /checkout
  def checkout
    cart = @current_user.cart

    if cart && cart.cart_items.any?
      total_cost = 0.0
      cart.cart_items.each do |item|
        product = item.product
        
        if product.nil? || product.inventory.nil? || product.inventory < item.quantity
          render json: { error: "Insufficient inventory for #{product&.name || 'unknown product'}" }, status: :unprocessable_entity and return
        end
        
        total_cost += product.price * item.quantity
      end

      ActiveRecord::Base.transaction do
        cart.cart_items.each do |item|
          item.product.update!(inventory: item.product.inventory - item.quantity)
        end
        cart.cart_items.destroy_all  # Clear the cart after successful checkout
      end

      render json: { message: 'Checkout successful', total_cost: total_cost }, status: :ok
    else
      render json: { error: 'Cart is empty' }, status: :bad_request
    end
  end

  private

    def cart_params
      params.require(:cart).permit(:product_id, :quantity)
    end

end