class NutritionFacts
    def initialize(barcode)
        product = Openfoodfacts::Product.get(barcode, locale: "world")
        nutrition = product.nutriments
        energy = nutrition["energy-kcal_100g"]
        carbs = nutrition["carbohydrates_100g"]
        fat = nutrition["fat_100g"]
        protein = nutrition["proteins_100g"]
        @nutrition = [{name: "Energy", value: energy}, {name: "Carbohydrates", value: carbs}, {name: "Fat", value: fat}, {name: "Protein", value: protein}]
    end

    def print_table
        table = Tabulo::Table.new(@nutrition, title: "Nutrition Facts (per 100g)") do |t|
            t.add_column("Component", width: 13) { |h| h[:name] }
            t.add_column("Amount") { |h| h[:value] }
        end
        puts table
    end
end