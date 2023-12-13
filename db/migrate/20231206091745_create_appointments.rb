class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.references :invoice, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: { to_table: :users }
      t.references :admin, null: false, foreign_key: { to_table: :users } 
      t.datetime :datetime
      t.string :link
      t.string :status

      t.timestamps
    end
  end
end
