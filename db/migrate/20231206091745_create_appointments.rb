class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.references :invoice, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :admin, null: false, foreign_key: { to_table: :users } 
      t.datetime :date
      t.string :link
      t.string :status

      t.timestamps
    end
  end
end
