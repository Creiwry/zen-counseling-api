class AddStripeCustomerIdToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :stripe_customer_id, :string
  end
end
