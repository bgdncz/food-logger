class Category < ActiveRecord::Base
    has_many :foods, through: :categories_foods
end