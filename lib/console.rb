class Console < TTY::Prompt
    def self.clear
        system("clear")
    end

    def self.greet
        clear
        puts <<-'EOF'
        ___             _   _                           
        | __|__  ___  __| | | |   ___  __ _ __ _ ___ _ _ 
        | _/ _ \/ _ \/ _` | | |__/ _ \/ _` / _` / -_) '_|
        |_|\___/\___/\__,_| |____\___/\__, \__, \___|_|  
                                    |___/|___/                        
        
        EOF
    end

    def create_user
        Console.greet
        user_name = self.ask("What is your name?")
        User.create(name: user_name)
    end

    def pick_user
        if User.count == 0
            puts "No users yet."
            create_user
        end
        loop do
            Console.greet
            choices = User.all.map {|user| {name: user.name, value: user}} << {name: "New user", value: nil}
            user = select("Select user:", choices)
            if user.nil?
                create_user
            else
                return user
            end
        end
    end
end