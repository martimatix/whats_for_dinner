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

  # Test 5: No recipes
  def test_5
    recipe_finder = RecipeFinder.new('my-fridge-1.csv', 'my-recipe-5.json')
    assert_equal 'Call for takeout', recipe_finder.perform
  end

  # Test 6: Mismatched units - cheese in fridge is 'block', not 'slice'
  def test_6
    recipe_finder = RecipeFinder.new('my-fridge-6.csv', 'my-recipe.json')
    assert_equal 'Vegemite Sandwich', recipe_finder.perform
  end

  # Test 7: Cheese expires first, multiple recipes with cheese
  #         Recipe listed first expected.
  def test_7
    recipe_finder = RecipeFinder.new('my-fridge-3.csv', 'my-recipe-7.json')
    assert_equal 'Cheese Omlette', recipe_finder.perform
  end

  # Test 8: Not enough cheese for omlette, other recipes valid
  def test_8
    recipe_finder = RecipeFinder.new('my-fridge-3.csv', 'my-recipe-8.json')
    assert_equal 'Toasted Cheese', recipe_finder.perform
  end

  # Test 9: Empty fridge
  def test_9
    recipe_finder = RecipeFinder.new('my-fridge-9.csv', 'my-recipe.json')
    assert_equal 'Call for takeout', recipe_finder.perform
  end
end
