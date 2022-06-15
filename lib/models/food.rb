class Food < ActiveRecord::Base
    has_many :categories, through: :categories_foods
    has_many :users, through: :users_foods
    belongs_to :brand
end