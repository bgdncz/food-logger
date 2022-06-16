class Food < ActiveRecord::Base
    ACTION_CHOICES = [{name: "Remove food item", value: :remove}, {name: "Print nutritional facts", value: :nutrition}, {name: "Go back", value: nil}]

    has_and_belongs_to_many :categories
    has_and_belongs_to_many :users
    belongs_to :brand

    def self.create_from_product(product, user)
        barcode = product._id
        existing_product = Food.find_by(barcode: barcode)
        if existing_product.nil?
            name = product.product_name
            brand = Brand.find_or_create_by(name: product.brands.split(",")[0])
            categories = product.categories_old.nil? ? [] : product.categories_old.split(", ").map! {|category_name| Category.find_or_create_by(name: category_name)}
            user.foods << Food.create(name: name, barcode: barcode, brand: brand, categories: categories)
        elsif !existing_product.users.include? user
            user.foods << existing_product
        end
    end

    def pretty_categories
        categories.map {|category| category.name}.join(", ")
    end

    def self.prompt_actions(user)
        prompt = TTY::Prompt.new
        action = prompt.select("What would you like to do?", ACTION_CHOICES)
        self.send(action, user) unless action.nil?
    end

    def self.nutrition(user)
        prompt = TTY::Prompt.new
        item_id = prompt.select("Which item would you like nutritional facts for?", user.foods.map{|food| {name: food.name, value: food.id}} << {name: "Cancel", value: -1})
        if item_id != -1
            facts = NutritionFacts.new Food.find(item_id).barcode
            facts.print_table
            prompt.keypress("Press any key to continue")
        end
    end

    def self.remove(user)
        prompt = TTY::Prompt.new
        item_id = prompt.select("Which item would you like to remove?", user.foods.map{|food| {name: food.name, value: food.id}} << {name: "Cancel", value: -1})
        if item_id != -1
            Food.destroy(item_id)
        end
    end
end