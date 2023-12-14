class CreateMessageRecipients < ActiveRecord::Migration[7.1]
  def change
    create_table :message_recipients do |t|
      t.references :private_message, foreign_key: { on_delete: :cascade }
      t.references :recipient, foreign_key: { to_table: :users, on_delete: :cascade }

      t.timestamps
    end
  end
end
