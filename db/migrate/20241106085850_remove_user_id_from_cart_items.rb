class RemoveUserIdFromCartItems < ActiveRecord::Migration[7.2]
  def change
    remove_column :cart_items, :remove_user_id_from_cart_items, :string
  end
end
