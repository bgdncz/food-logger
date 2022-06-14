require_relative '../config/environment'

def greet
    puts <<-'EOF'
    ___             _   _                           
    | __|__  ___  __| | | |   ___  __ _ __ _ ___ _ _ 
    | _/ _ \/ _ \/ _` | | |__/ _ \/ _` / _` / -_) '_|
    |_|\___/\___/\__,_| |____\___/\__, \__, \___|_|  
                                  |___/|___/                        
    
    EOF
end

greet

binding.pry
