class User < ActiveRecord::Base
    has_many :foods
    has_many :keywords, through: :foods
    has_many :categories, through: :foods
end