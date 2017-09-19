class AddReturnTimeToProducts < SpreeExtension::Migration[4.2]
  def change
    add_column :spree_products, :return_time, :integer, default: 0, null: false

    Spree::Product.reset_column_information
    Spree::Product.all.each do |product|
      product.update_attribute(:return_time, 0)
    end
  end
end
