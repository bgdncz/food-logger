ACTION_CHOICES = ["Log food item", "Print food table", "Delete profile"]
ACTION_METHODS = ["log_new", "print_foods", "delete_profile"]

class User < ActiveRecord::Base
    has_and_belongs_to_many :foods
    has_many :categories, through: :foods
    has_many :brands, through: :foods

    def greet
        Console.greet
        puts "Welcome, #{name}!"
    end

    def prompt_actions
        choice = Console.prompt_choices("What would you like to do?", ACTION_CHOICES, back_message: nil)
        if choice != -1
            self.send(ACTION_METHODS[choice])
        end
    end

    def print_foods
        #if user.foods.count == 0
        #    puts "You haven't added any products yet."
        #    product = ask_barcode
        #    user.foods << Food.new(name: product.product_name, barcode: product._id, brand: Brand.find_or_create_by(name: product.brands))
        #else
            rows = foods.map {|food| [food.name, food.brand.name, food.barcode]}
            table = Terminal::Table.new :title => "Your foods", :headings => ['Name', 'Brand', 'Barcode'], :rows => rows
            puts table
        #end
    end
end