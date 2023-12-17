# frozen_string_literal: true

class CreateUpdates < ActiveRecord::Migration[7.1]
  def change
    create_table :updates do |t|
      t.string :title
      t.text :content
      t.references :admin, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
