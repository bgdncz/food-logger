class CreateCategoriesFoods < ActiveRecord::Migration[4.2]
    def change
      create_table :categories_foods do |t|
        t.references :food
        t.references :category
      end
    end
  end 