class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.references :item, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :current_price
      t.boolean :is_active
      t.integer :best_bidder_id

      t.timestamps null: false
    end
  end
end
