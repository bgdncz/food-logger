class CreateUsersFoods < ActiveRecord::Migration[4.2]
    def change
        create_join_table :users, :foods
    end
  end 