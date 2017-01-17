class AddReturnableFieldToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :returnable, :boolean, default: false
  end
end
