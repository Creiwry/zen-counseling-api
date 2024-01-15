class RemoveStripeCustomerIdFromInvoices < ActiveRecord::Migration[7.1]
  def change
    remove_column :invoices, :stripe_customer_id, :string
  end
end
