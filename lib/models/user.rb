class User < ActiveRecord::Base
    has_many :foods, through: :users_foods
    has_many :categories, through: :foods
    has_many :brands, through: :foods
end