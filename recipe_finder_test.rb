require_relative './recipe_finder.rb'
require 'minitest/autorun'

class RecipeFinderTest < MiniTest::Test
  # Test 1: Example Scenario
  def test_1
    recipe_finder = RecipeFinder.new('my-fridge-1.csv', 'my-recipe.json')
    assert_equal 'Vegemite Sandwich', recipe_finder.perform
  end

  # Test 2: Sufficient ingredients for Toasted Cheese, not for Vegemite Sandwich
  def test_2
    recipe_finder = RecipeFinder.new('my-fridge-2.csv', 'my-recipe.json')
    assert_equal 'Toasted Cheese', recipe_finder.perform
  end

  # Test 3: Sufficient ingredients for both Toasted Cheese and Vegemite Sandwich
  #         but cheese expires first
  def test_3
    recipe_finder = RecipeFinder.new('my-fridge-3.csv', 'my-recipe.json')
    assert_equal 'Toasted Cheese', recipe_finder.perform
  end

  # Test 4: Not enough ingredients
  def test_4
    recipe_finder = RecipeFinder.new('my-fridge-4.csv', 'my-recipe.json')
    assert_equal 'Call for takeout', recipe_finder.perform
  end
end
