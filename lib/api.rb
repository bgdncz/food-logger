require 'net/http'
require 'open-uri'
require 'json'

class OpenFoodFacts
    def self.get_by_barcode(code)
        url = URI.parse("https://world.openfoodfacts.org/api/v0/product/#{code}.json")
        response = Net::HTTP.get_response(url)
        JSON.parse(response.body)
    end

    def self.get_by_name(name)
        url = URI.parse("https://world.openfoodfacts.org/api/v2/search?product_name=#{name}")
    end
end