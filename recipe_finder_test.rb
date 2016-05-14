require_relative './recipe_finder.rb'
require 'minitest/autorun'

class RecipeFinderTest < MiniTest::Test
  # Example Scenarios
  def test_1
    recipe_finder = RecipeFinder.new('my-fridge.csv', 'my-recipe.json')
    assert_equal 'Vegemite Sandwich', recipe_finder.perform
  end
end
