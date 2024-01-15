class AddRefundableToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :refundable, :boolean, default: false
  end
end
