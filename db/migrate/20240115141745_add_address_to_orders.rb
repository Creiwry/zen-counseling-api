class AddAddressToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :zip_code, :string
    add_column :orders, :city, :string
    add_column :orders, :country, :string
    add_column :orders, :street_address, :string
  end
end
