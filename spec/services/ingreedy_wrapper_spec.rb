# frozen_string_literal: true

require "rails_helper"

RSpec.describe IngreedyWrapper do
  describe ".parse" do
    {
      "3 tablespoons tomato paste" => {
        amount: 3,
        unit: :Tbs,
        ingredient: "tomato paste"
      },
      "Kosher Salt" => {
        amount: 0,
        unit: nil,
        ingredient: "Kosher Salt"
      },
      "Salt to taste" => {
        amount: 0,
        unit: nil,
        ingredient: "Salt to taste"
      },
      "Fine sea salt, to taste (I use 1 1/2 teaspoons pink salt)" => {
        amount: 1.5,
        unit: :tsp,
        ingredient: "Fine sea salt, to taste"
      },
      "   1    cup test  " => {
        amount: 1,
        unit: :cup,
        ingredient: "test"
      },
      "3 boneless skinless chicken breasts, cut into bite-size pieces" => {
        amount: 3,
        unit: nil,
        ingredient: "boneless skinless chicken breasts, " \
                    "cut into bite-size pieces"
      },
      "1 (8 ounce) can tomato sauce" => {
        amount: 8,
        unit: "fl-oz",
        ingredient: "can tomato sauce"
      },
      "3 (8 ounce) can tomato sauce" => {
        amount: 24,
        unit: "fl-oz",
        ingredient: "can tomato sauce"
      },
      "1 (15-ounce) can chickpeas " \
      "or 1 1/2 cups (250 grams) cooked chickpeas" => {
        amount: 15,
        unit: "fl-oz",
        ingredient: "can chickpeas or 1 1/2 cups (250 grams) cooked chickpeas"
      },
      "1/4 cup (60 ml) fresh lemon juice (1 large lemon)" => {
        amount: 0.25,
        unit: :cup,
        ingredient: "fresh lemon juice (1 large lemon)"
      },
      "1/2 teaspoon ground cumin" => {
        amount: 0.5,
        unit: :tsp,
        ingredient: "ground cumin"
      },
      "1/3 cup freshly grated romano cheese + more for topping" => {
        amount: 0.34,
        unit: :cup,
        ingredient: "freshly grated romano cheese + more for topping"
      },
      "Handful of fresh cilantro" => {
        amount: nil,
        unit: :handful,
        ingredient: "fresh cilantro"
      },
      "pinch Red pepper flakes, optional for extra heat" => {
        amount: nil,
        unit: :pinch,
        ingredient: "Red pepper flakes, optional for extra heat"
      },
      "About 1/2 teaspoon salt" => {
        amount: 0.5,
        unit: :tsp,
        ingredient: "salt"
      },
      "1 lb. of stuff" => {
        amount: 1,
        unit: :lb,
        ingredient: "stuff"
      },
      "1-2 tsp red chili" => {
        amount: 2,
        unit: :tsp,
        ingredient: "red chili"
      }
    }.each do |ingredient_text, expected_value|
      it "returns expected parsing results for #{ingredient_text}" do
        parsed_ingredient = IngreedyWrapper.parse(ingredient_text)

        expect(parsed_ingredient.amount).to eq expected_value[:amount]
        expect(parsed_ingredient.unit.to_s).to eq expected_value[:unit].to_s
        expect(parsed_ingredient.ingredient).to eq expected_value[:ingredient]
      end
    end

    it "raises a ParseFailure when unable to parse an ingredient" do
      expect(Ingreedy).to receive(:parse).and_raise(Ingreedy::ParseFailed)
      expect(IngreedyWrapper).to receive(:handle_exception)

      expect { IngreedyWrapper.parse("Zest from 1 lemon, divided") }.
        to raise_error(
          IngreedyWrapper::ParseFailure,
          "Unable to parse ingredient \"Zest from 1 lemon, divided\""
        )
    end
  end
end
