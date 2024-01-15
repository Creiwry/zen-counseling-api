class RemoveAddressFromOrders < ActiveRecord::Migration[7.1]
  def change
    remove_column :orders, :address
  end
end
