class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.references :user, index: true, foreign_key: true
      t.string :item_name
      t.integer :start_price

      t.timestamps null: false
    end
  end
end
