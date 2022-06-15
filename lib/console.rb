class Console
    def self.clear
        system("clear")
    end

    def self.greet
        clear
        puts <<-EOF
        ___             _   _                           
        | __|__  ___  __| | | |   ___  __ _ __ _ ___ _ _ 
        | _/ _ \/ _ \/ _` | | |__/ _ \/ _` / _` / -_) '_|
        |_|\___/\___/\__,_| |____\___/\__, \__, \___|_|  
                                    |___/|___/                        
        
        EOF
    end

    def self.prompt(text)
        puts text
        gets.chomp
    end

    def self.prompt_choices(text, choices, back_message: "Go back")
        loop do
            puts text
            puts
            choices.each_with_index {|choice, i| puts "#{i+1}) #{choice}"}
            puts
            puts "* #{back_message}" unless back_message.nil?
            input = gets.chomp
            if input == "*"
                return -1
            elsif input.to_i == 0
                puts "Wrong input"
            else
                return input.to_i-1
            end
        end
    end

    def self.create_user
        Console.greet
        user_name = Console.prompt("Enter new user name:")
        User.create(name: user_name)
        greet
    end

    def self.pick_user
        loop do
            if User.count == 0
                puts "No users yet."
                Console.create_user
            end
            input = Console.prompt_choices("Select user:", User.all.map {|user| user.name}, back_message: "Create a new user")
            
            # create new user
            if input == -1
                create_user
            else
                chosen_user = User.all[input]
                if chosen_user.nil?
                    puts "No such user"
                    puts
                else
                    return chosen_user
                end 
            end
        end
    end
end