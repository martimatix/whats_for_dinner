class RecipeFinder

  attr_reader :fridge_csv, :recipes_json

  def initialize(fridge_csv, recipes_json)
    @fridge_csv = fridge_csv
    @recipes_json = recipes_json
  end

  def perform
    return 'Vegemite Sandwich'
  end
end
