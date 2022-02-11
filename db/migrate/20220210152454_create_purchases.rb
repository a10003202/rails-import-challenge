class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.references :buyer, foreign_key: true
      t.references :item, foreign_key: true
      t.references :seller, foreign_key: true
      t.integer :total_items
      t.decimal :total_price, precision: 12, scale: 2

      t.timestamps
    end
  end
end
