class ProductsController < BaseController
  before_action :authorize_admin!, only: [:create, :update, :destroy]

  # GET /products
  def index
    products = Product.all
    render json: { products: products }  # Wrap products in a hash
  end

  # POST /products
  def create
    product = Product.new(product_params)
    if product.save
      render json: { product: product, message: 'Product created successfully' }, status: :created
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/:id
  def update
    product = Product.find_by(id: params[:id])
    if product.nil?
      render json: { error: 'Product not found' }, status: :not_found
    elsif product.update(product_params)
      render json: { product: product, message: 'Product updated successfully' }
    else
      render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /products/:id
  def destroy
    product = Product.find_by(id: params[:id])
    if product.nil?
      render json: { error: 'Product not found' }, status: :not_found
    else
      product.destroy
      render json: { message: 'Product deleted successfully' }, status: :ok
    end
  end

  private

  def authorize_admin!
    render json: { error: 'Forbidden' }, status: :forbidden unless current_user&.admin?
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :inventory)
  end
end