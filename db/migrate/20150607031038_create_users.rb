class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :budget
      t.text :owned_item_ids, array:true, default: []
      t.integer :blocked_budget

      t.timestamps null: false
    end
  end
end
