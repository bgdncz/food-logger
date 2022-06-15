class Food < ActiveRecord::Base
    has_and_belongs_to_many :categories
    has_and_belongs_to_many :users
    belongs_to :brand
end