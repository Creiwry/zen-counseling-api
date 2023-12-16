# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :title
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.integer :stock

      t.timestamps
    end
  end
end
