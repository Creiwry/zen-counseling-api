class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.integer :appointment_number
      t.decimal :total
      t.string :status
      t.references :client, null: false, foreign_key: { to_table: :users }
      t.references :admin, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
