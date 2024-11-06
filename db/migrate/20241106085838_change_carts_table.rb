class ChangeCartsTable < ActiveRecord::Migration[7.2]
  def change
    remove_column :carts, :product_id
    remove_column :carts, :quantity
  end
end
