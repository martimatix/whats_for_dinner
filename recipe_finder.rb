require 'json'
require 'csv'

class RecipeFinder
  attr_reader :fridge_csv, :recipes_json

  class FileNotFoundError < StandardError; end
  CSV_KEYS = %w(item quantity unit-of-measure use-by-date)

  def initialize(fridge_csv, recipes_json)
    @fridge_csv = fridge_csv
    @recipes_json = recipes_json
  end

  def perform
    raise FileNotFoundError.new('fridge csv could not be found.') unless File.file?(fridge_csv)
    raise FileNotFoundError.new('recipe json could not be found.') unless File.file?(recipes_json)
    recipe_finder
  end

  private

  def recipe_finder
    return 'Call for takeout' if fridge.empty? || recipes.empty?
    fridge_item = fridge.first
    recipe = find_recipe(fridge_item)
    return recipe['name'] if recipe
    fridge.shift
    recipe_finder
  end

  def find_recipe(fridge_item)
    # partion recipes into those that contain the fridge_item and those that don't
    recipes_partioned = recipes.partition do |recipe|
                          recipe_contains_ingredient?(recipe, fridge_item)
                        end
    recipes_with_ingredient = recipes_partioned[0]
    recipes = recipes_partioned[1]
    find_recipe_with_all_ingredients_in_fridge(recipes_with_ingredient)
  end

  def find_recipe_with_all_ingredients_in_fridge(recipes_with_ingredient)
    recipes_with_ingredient.find do |recipe|
      all_ingredients_in_fridge?(recipe['ingredients'])
    end
  end

  def all_ingredients_in_fridge?(recipe_ingredients)
    recipe_ingredients.all? do |recipe_ingredient|
      fridge_ingredient = find_in_fridge(recipe_ingredient)
      sufficient_amount_in_fridge?(fridge_ingredient, recipe_ingredient) if fridge_ingredient
    end
  end

  def sufficient_amount_in_fridge?(fridge_ingredient, recipe_ingredient)
    fridge_ingredient['quantity'].to_i >= recipe_ingredient['quantity'].to_i &&
      fridge_ingredient['unit-of-measure'] == recipe_ingredient['unit-of-measure']
  end

  def find_in_fridge(recipe_ingredient)
    fridge.find { |fridge_ingredient| fridge_ingredient['item'] == recipe_ingredient['item'] }
  end

  def recipe_contains_ingredient?(recipe, fridge_item)
    recipe['ingredients'].any? { |ingredient| ingredient['item'] == fridge_item['item'] }
  end

  # fridge items as array & sorted by use-by-date
  def fridge
    @fridge ||= CSV.read(fridge_csv)
                  .map { |item_info| Hash[ CSV_KEYS.zip(item_info) ] }
                  .sort_by { |item| Date.parse(item['use-by-date']) }
  end

  def recipes
    contents = File.open(recipes_json, 'rb').read
    @recipes ||= JSON.parse(contents)
  end
end
