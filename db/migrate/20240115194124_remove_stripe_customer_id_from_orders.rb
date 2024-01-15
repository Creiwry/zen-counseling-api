class RemoveStripeCustomerIdFromOrders < ActiveRecord::Migration[7.1]
  def change
    remove_column :orders, :stripe_customer_id, :string
  end
end
