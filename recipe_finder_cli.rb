require_relative './recipe_finder.rb'

def recipe_finder_cli
  puts "\nWhat is the file name of fridge items in csv format?"

  fridge_csv = gets.chomp

  sleep 0.5

  puts "\nWhat is the file name of recipes in json format?"

  recipe_json = gets.chomp

  puts "\nOutput:\n"
  puts RecipeFinder.new(fridge_csv, recipe_json).perform

  sleep 1
end

recipe_finder_cli
