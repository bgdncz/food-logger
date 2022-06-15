require_relative '../config/environment'

def greet
    system("clear")
    puts <<-'EOF'
    ___             _   _                           
    | __|__  ___  __| | | |   ___  __ _ __ _ ___ _ _ 
    | _/ _ \/ _ \/ _` | | |__/ _ \/ _` / _` / -_) '_|
    |_|\___/\___/\__,_| |____\___/\__, \__, \___|_|  
                                  |___/|___/                        
    
    EOF
end

def create_user
    greet
    puts "Enter new user name:"
    user_name = gets.chomp
    User.create(name: user_name)
    greet
end

def ask_for_user
    loop do
        if User.count == 0
            puts "No users yet."
            create_user
        end
        puts "Select user:"
        User.all.each_with_index {|user, i| puts "#{i+1}) #{user.name}"}
        puts
        puts "Or enter * to create a new user"
        input = gets.chomp
        if input == "*"
            create_user
        elsif input.to_i == 0
            puts "Wrong input"
        else
            chosen_user = User.all[input.to_i-1]
            if chosen_user.nil?
                puts "Wrong input"
            else
                return chosen_user
            end 
        end
    end
end

def ask_barcode
    puts "Please enter a barcode: "
    barcode = gets.chomp
    OpenFoodFacts.get_by_barcode(barcode)
end

old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

greet
user = ask_for_user
greet
puts "Welcome #{user.name}!"

