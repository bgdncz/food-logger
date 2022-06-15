require 'openfoodfacts'
require 'terminal-table'
require_relative '../config/environment'

def ask_barcode
    loop do
        puts "Please enter a barcode: "
        barcode = gets.chomp
        product = Openfoodfacts::Product.get(barcode, locale: "world")
        if product.nil?
            "Product with barcode #{barcode} not found."
        else
            return product
        end
    end
end

Console.greet
user = Console.pick_user
user.greet
user.prompt_actions
