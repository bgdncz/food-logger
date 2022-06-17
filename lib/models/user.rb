class User < ActiveRecord::Base
    ACTION_CHOICES = [{name: "Log food item", value: :log_new}, {name: "List foods", value: :print_foods}, {name: "List brands", value: :print_brands}, {name: "List categories", value: :print_categories}, {name: "Change name", value: :change_name} , {name: "Delete profile", value: :delete_profile}, {name: "Quit", value: :quit}]
    BARCODE_SEARCH = [{name: "Look up by barcode", value: :log_barcode}, {name: "Search by name", value: :search}, {name: "Go back", value: :back}]

    has_and_belongs_to_many :foods
    has_many :categories, through: :foods
    has_many :brands, through: :foods

    def greet
        Console.greet
        puts "Welcome, #{name}!"
    end

    def prompt_actions
        prompt = TTY::Prompt.new
        action = prompt.select("What would you like to do?", ACTION_CHOICES, per_page: 10)
        if action == :quit
            return :quit
        end
        self.send(action)
        self.reload unless action == :delete_profile
    end

    def log_barcode
        barcode = prompt.ask("Please enter a barcode:") { |q| q.validate /\d+/ }
        product = Openfoodfacts::Product.get(barcode, locale: "world")
        if product.nil?
            puts "Product with barcode #{barcode} not found."
            prompt.keypress("Press any key to continue")
        else
            Food.create_from_product(product, self)
        end
    end

    def search
        prompt = TTY::Prompt.new
        name = prompt.ask("Please enter product name:")
        products = Openfoodfacts::Product.search(name, locale: 'world', page_size: 10)
        product_choices = products.map {|product| {name: product.product_name, value: product._id}}
        barcode = prompt.select("Please select food item:", product_choices, per_page: 10)
        product = Openfoodfacts::Product.get(barcode, locale: "world")
        Food.create_from_product(product, self)
    end

    def log_new
        prompt = TTY::Prompt.new
        action = prompt.select("", BARCODE_SEARCH)
        self.send(action) unless action == :back
    end

    def print_foods
        prompt = TTY::Prompt.new
        if foods.count == 0
            puts "You haven't added any products yet."
            prompt.keypress("Press any key to continue")
        else
            #rows = foods.map {|food| [food.name, food.brand.name, food.categories.map {|category| category.name}.join(", "), food.barcode]}
            table = Tabulo::Table.new(foods, title: "Your foods") do |t|
                t.add_column("Name", &:name)
                t.add_column("Brand") {|food| food.brand.name}
                t.add_column("Categories", &:pretty_categories)
                t.add_column("Barcode", &:barcode)
            end
            puts table.pack
            Food.prompt_actions self
        end
    end

    def print_brands
        prompt = TTY::Prompt.new
        if foods.count == 0
            puts "You haven't added any products yet."
            prompt.keypress("Press any key to continue")
        else
            table = Tabulo::Table.new(brands, title: "Your favorite brands") do |t|
                t.add_column("Name", &:name)
                t.add_column("No. of products") {|brand| brand.foods.count}
            end
            puts table.pack
            prompt.keypress("Press any key to continue")
        end
    end

    def print_categories
        prompt = TTY::Prompt.new
        if foods.count == 0
            puts "You haven't added any products yet."
            prompt.keypress("Press any key to continue")
        else
            table = Tabulo::Table.new(categories, title: "Your food categories") do |t|
                t.add_column("Name", &:name)
                t.add_column("No. of products") {|category| category.foods.count}
            end
            puts table.pack
            prompt.keypress("Press any key to continue")
        end
    end

    def change_name
        prompt = TTY::Prompt.new
        self.name = prompt.ask("What's your name?")
        self.save
    end
    
    def delete_profile
        prompt = TTY::Prompt.new
        if prompt.yes?("Are you sure you want to delete your profile?")
            self.delete
        end
    end

    def quit
        return :quit
    end
end