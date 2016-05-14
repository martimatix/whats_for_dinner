require 'json'
require 'csv'
require 'pry'

class RecipeFinder
  attr_reader :fridge_csv, :recipes_json

  CSV_KEYS = %w(item quantity unit-of-measure use-by-date)

  def initialize(fridge_csv, recipes_json)
    @fridge_csv = fridge_csv
    @recipes_json = recipes_json
  end

  def perform
    binding.pry
    'Vegemite Sandwich'
  end

  private

  # fridge items as array sorted by use-by-date
  def fridge
    @fridge ||= CSV.read(fridge_csv)
                  .map { |item_info| Hash[ CSV_KEYS.zip(item_info) ] }
                  .sort_by { |item| Date.parse(item['use-by-date']) }
  end

  def recipes
    contents = file_contents(recipes_json)
    @recipes ||= JSON.parse(contents)
  end

  def file_contents(file_name)
    File.open(file_name, 'rb').read
  end
end

RecipeFinder.new('my-fridge-1.csv', 'my-recipe.json').perform
