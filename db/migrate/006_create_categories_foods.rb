class CreateCategoriesFoods < ActiveRecord::Migration[4.2]
    def change
        create_join_table :categories, :foods
    end
  end 