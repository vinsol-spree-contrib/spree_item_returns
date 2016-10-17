class AddUserInitiatedToReturnAuthorizations < ActiveRecord::Migration
  def change
    add_column :spree_return_authorizations, :user_initiated, :boolean, default: false
  end
end
