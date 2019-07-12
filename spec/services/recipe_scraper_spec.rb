# frozen_string_literal: true

RSpec.describe RecipeScraper do
  before do
    allow(FileUtils).to receive(:rm) # don't delete the test file
  end

  describe "#scrape" do
    it "returns a failed response if reicpe link is missing" do
      recipe = Recipe.new
      result = RecipeScraper.new(recipe).scrape("")

      expect(result.success).to be false
      expect(result.errors.first.message).
        to eq(I18n.t("recipe_scraper.missing_link_error"))
    end

    it "returns a failed response if the script returns error message" do
      recipe = Recipe.new
      scraper = RecipeScraper.new(recipe)

      allow(scraper).to receive(:scrape_output).and_return("Error!")

      result = scraper.scrape("www.somerecipe.com")
      expect(result.success).to be false
      expect(result.errors.first.message).to eq("Error!")
    end

    it "returns a failed response if script does not create an output file" do
      recipe = Recipe.new
      scraper = RecipeScraper.new(recipe)

      allow(scraper).to receive(:scrape_output).and_return("Success!")

      result = scraper.scrape("www.somerecipe.com")
      expect(result.success).to be false
      expect(result.errors.first.message).
        to eq(I18n.t("recipe_scraper.missing_data_file"))
    end

    context "sucessfully creating a data file" do
      it "successfully fetches, parses, and updates the recipe" do
        file_path = Rails.root.join(
          "spec", "support", "data_files", "sample_recipe_data.json"
        )
        stub_const("RecipeScraper::DATA_FILE_PATH", file_path)

        recipe = Recipe.new
        scraper = RecipeScraper.new(recipe)

        allow(scraper).to receive(:scrape_output).and_return("Success!")

        result = scraper.scrape("www.somerecipe.com")
        expect(result.success).to be true
        expect(result.errors).to be_blank

        recipe = result.recipe.send(:resource)
        expect(recipe.link).to eq "www.somerecipe.com"
        expect(recipe.name).to eq "Chicken Tikka Masala"
        expect(recipe.cook_time_quantity).to eq 140
        expect(recipe.cook_time_unit).to eq "minutes"
        expect(recipe.step_text).to be_present
        expect(recipe.ingredients_recipes.size).to eq 19
        # ensure missing ingredients have been created
        expect(Ingredient.count).to eq 18
      end
    end
  end
end
