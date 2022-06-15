class CreateUsersFoods < ActiveRecord::Migration[4.2]
    def change
      create_table :users_foods do |t|
        t.references :food
        t.references :user
      end
    end
  end 