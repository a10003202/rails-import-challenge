class CreateGalleries < ActiveRecord::Migration[5.2]
  def change
    create_table :galleries do |t|
      t.string :name
      t.string :file
      t.integer :image_type
      t.integer :order
      t.references :owner, polymorphic: true

      t.timestamps
    end
  end
end
