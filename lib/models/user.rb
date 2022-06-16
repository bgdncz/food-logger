class User < ActiveRecord::Base
    ACTION_CHOICES = [{name: "Log food item", value: :log_new}, {name: "List foods", value: :print_foods}, {name: "List brands", value: :print_brands}, {name: "List categories", value: :print_categories}, {name: "Change name", value: :change_name} , {name: "Delete profile", value: :delete_profile}]

    has_and_belongs_to_many :foods
    has_many :categories, through: :foods
    has_many :brands, through: :foods

    def greet
        Console.greet
        puts "Welcome, #{name}!"
    end

    def prompt_actions
        prompt = TTY::Prompt.new
        action = prompt.select("What would you like to do?", ACTION_CHOICES)
        self.send(action)
    end

    # barcode = product._id
    # brand = product.brands
    # categories = "en:Snacks, en:Salty snacks"
    # "manufacturing_places"=>"Bulgaria"
    #nutriments "carbohydrates_100g"=>6


    def log_new
        prompt = TTY::Prompt.new
        barcode = prompt.ask("Please enter a barcode:") { |q| q.validate /\d+/ }
        product = Openfoodfacts::Product.get(barcode, locale: "world")
        #binding.pry
        if product.nil?
            puts "Product with barcode #{barcode} not found."
            prompt.keypress("Press any key to continue")
        else
            foods << Food.create_from_product(product)
        end
    end

    def print_foods
        if foods.count == 0
            prompt = TTY::Prompt.new
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
            Food.prompt_actions
            #table = TTY::Table.new header: ['Name', 'Brand', 'Categories', 'Barcode'], rows: rows
            #table.render(:unicode, multiline: true)
        end
    end

    def print_brands
        if foods.count == 0
            prompt = TTY::Prompt.new
            puts "You haven't added any products yet."
            prompt.keypress("Press any key to continue")
            greet
            prompt_actions
        else
            table = Tabulo::Table.new(brands, title: "Your favorite brands") do |t|
                t.add_column("Name", &:name)
                t.add_column("No. of products") {|brand| brand.foods.count}
            end
            puts table.pack
        end
    end

    def print_categories
        if foods.count == 0
            prompt = TTY::Prompt.new
            puts "You haven't added any products yet."
            prompt.keypress("Press any key to continue")
            greet
            prompt_actions
        else
            table = Tabulo::Table.new(categories, title: "Your food categories") do |t|
                t.add_column("Name", &:name)
                t.add_column("No. of products") {|category| category.foods.count}
            end
            puts table.pack
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
end