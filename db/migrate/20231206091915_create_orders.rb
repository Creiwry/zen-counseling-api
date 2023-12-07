class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :stripe_customer_id
      t.decimal :total, precision: 10, scale: 2
      t.string :address
      t.string :status

      t.timestamps
    end
  end
end
