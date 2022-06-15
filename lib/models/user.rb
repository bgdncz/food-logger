class User < ActiveRecord::Base
    has_and_belongs_to_many :foods
    has_many :categories, through: :foods
    has_many :brands, through: :foods
end