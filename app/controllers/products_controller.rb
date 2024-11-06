# app/controllers/products_controller.rb
class ProductsController < BaseController
    before_action :authorize_admin, only: [:create, :update, :destroy]
  
    # GET /products
    def index
      products = Product.all
      render json: products
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
      product = Product.find(params[:id])
      if product.update(product_params)
        render json: { product: product, message: 'Product updated successfully' }
      else
        render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    # DELETE /products/:id
    def destroy
      product = Product.find(params[:id])
      product.destroy
      render json: { message: 'Product deleted successfully' }, status: :ok
    end
  
    private
  
    def product_params
      params.permit(:name, :description, :price, :inventory)
    end
  end