class CreatePrivateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :private_messages do |t|
      t.text :content
      t.references :recipient, foreign_key: { to_table: :users, on_delete: :cascade }
      t.references :sender, foreign_key: { to_table: :users, on_delete: :cascade }

      t.timestamps
    end
  end
end
