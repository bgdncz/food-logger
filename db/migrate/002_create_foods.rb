class CreateFoods < ActiveRecord::Migration[4.2]
    def change
      create_table :foods do |t|
        t.string :name
        t.integer :barcode
        t.references :category
        t.references :keyword
      end
    end
  end 