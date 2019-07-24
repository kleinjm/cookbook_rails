# frozen_string_literal: true

class RecipeScraper
  DATA_FILE_PATH = "tmp/recipe_data.json"
  SCRIPT_PATH = Rails.root.join("lib", "recipe_scraper.py")

  class MissingUrlError < StandardError; end
  class ScrapeFailure < StandardError; end
  class MissingFileError < StandardError; end

  attr_reader :recipe

  def initialize(recipe)
    @recipe = recipe
  end

  # Returns a response with an instance of the given recipe.
  # Does not persist updates of the recipe, however, it will create missing
  # units and ingredients
  def scrape(url)
    validate_url(url)
    run_and_validate_scrape
    parse_json
    update_recipe_attributes
    response(success: true)
  rescue StandardError => e
    response(success: false, errors: Array(e))
  ensure
    FileUtils.rm(DATA_FILE_PATH) if recipe_data_file_exists?
  end

  private

  attr_accessor :json, :url

  def recipe_data_file_exists?
    File.exist?(DATA_FILE_PATH)
  end

  def parse_json
    file = File.read(DATA_FILE_PATH)
    @json = JSON.parse(file)
  end

  def validate_url(url)
    @url = url
    return if url.present?

    raise(MissingUrlError, I18n.t("recipe_scraper.missing_link_error"))
  end

  def scrape_output
    @scrape_output ||= `python #{SCRIPT_PATH} #{url}`
  end

  def run_and_validate_scrape
    raise ScrapeFailure, scrape_output if scrape_output.downcase.match?(/error/)
    return if recipe_data_file_exists?

    raise MissingFileError, I18n.t("recipe_scraper.missing_data_file")
  end

  def update_recipe_attributes
    set_link
    set_title
    set_cook_time
    set_step_text
    set_ingredients
  end

  def set_link
    recipe.link = url
  end

  def set_title
    return if json["title"].blank?

    recipe.name = json["title"].strip.titleize
  end

  def set_cook_time
    return if json["total_time"].blank?

    recipe.cook_time_quantity = json["total_time"]
    recipe.cook_time_unit = "minutes"
  end

  def set_step_text
    recipe.steps = json["instructions"].chomp
  end

  def set_ingredients
    IngredientParser.new(json["ingredients"]).assign_to_recipe(recipe)
  end

  def response(success: true, errors: [])
    {
      recipe: recipe,
      errors: errors,
      success: success
    }
  end
end
