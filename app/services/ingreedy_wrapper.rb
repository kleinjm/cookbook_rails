# frozen_string_literal: true

# add additional functionality/error handling to Ingreedy gem
class IngreedyWrapper
  class ParseFailure < StandardError; end

  STANDARD_UNITS_MAPPING = {
    "Tbs": [:tablespoon, :tablespoons],
    "cup": [:c, :cups],
    "fl-oz": [:ounce, :ounces],
    "g": [:gram],
    "l": [],
    "lb": [:lbs, "lb.", :pound, :pounds],
    "ml": [:milliliter],
    "oz": [],
    "pnt": [:pint],
    "qt": [:quart],
    "tsp": [:teaspoon, :teaspoons, :t]
  }.freeze

  class << self
    def parse(ingredient_text)
      ingredient_text = clean_ingredient_text(ingredient_text)
      ingredient = Ingreedy.parse(ingredient_text)
      handle_to_taste(ingredient)
      compute_amount(ingredient)
      compute_unit(ingredient)
      standardize_unit(ingredient)
      ingredient
    rescue Ingreedy::ParseFailed
      ingredient = handle_exception(ingredient_text)
      standardize_unit(ingredient)
      return ingredient if ingredient.present?

      raise ParseFailure, "Unable to parse ingredient \"#{ingredient_text}\""
    end

    private

    def clean_ingredient_text(ingredient_text)
      # starting with about blows up
      ingredient_text.sub(/^about/i, "").split.join(" ").strip
    end

    # handle an odd case where "to taste" becomes the unit.
    # Change to the original text and a nil unit
    def handle_to_taste(ingredient)
      return unless ingredient.unit == :to_taste

      ingredient.ingredient = ingredient.original_query
      ingredient.unit = nil
      ingredient.amount = 0
    end

    def compute_amount(ingredient)
      amounts_present =
        ingredient.amount.present? && ingredient.container_amount.present?

      # if unit is present, the text is not in the form "1 30 oz ..."
      if amounts_present && ingredient.unit.blank?
        # total amount = amount * container_amount. ie. 30 oz = 2 x 15 oz can
        ingredient.amount =
          (ingredient.amount.to_f * ingredient.container_amount.to_f)
      end
      ingredient.amount = calculate_amount_number(ingredient.amount)
    end

    def calculate_amount_number(amount)
      return if amount.blank?

      # 1-2 tbsp => gets parsed into [(1/1), (2/1)]
      amount = amount.max if amount.is_a?(Array)
      amount.ceil(2)
    end

    def compute_unit(ingredient)
      ingredient.unit = ingredient.container_unit if ingredient.unit.blank?
    end

    def standardize_unit(ingredient)
      unless STANDARD_UNITS_MAPPING.values.flatten.include?(ingredient&.unit)
        return
      end

      standard_unit = STANDARD_UNITS_MAPPING.select do |_, mapping_units|
        mapping_units.include?(ingredient.unit)
      end.keys.first
      ingredient.unit = standard_unit
    end

    def handle_exception(ingredient_text)
      handle_missing_quantity(ingredient_text) || handle_parens(ingredient_text)
    end

    def handle_missing_quantity(ingredient_text)
      missing_quantity = (ingredient_text =~ /\d/).blank?
      return if missing_quantity.blank?

      Ingreedy::Parser::Result.new(
        0, nil, 0, nil, ingredient_text, ingredient_text
      )
    end

    def handle_parens(ingredient_text)
      contains_parens = (ingredient_text =~ /\(|\)/).present?
      return unless contains_parens

      # remove all text up to the first number
      opening_paren_index = ingredient_text =~ /\(/
      closing_paren_index = ingredient_text =~ /\)/
      text_between_parens =
        ingredient_text[(opening_paren_index + 1)..(closing_paren_index - 1)]

      first_number = text_between_parens.each_char.find { |c| c.to_i == 1 }

      first_number_index = text_between_parens.index first_number
      reparse_text =
        text_between_parens[first_number_index..closing_paren_index]

      build_ingredient_result(
        ingredient_text: ingredient_text, reparse_text: reparse_text
      )
    end

    def build_ingredient_result(ingredient_text:, reparse_text:)
      # run the remaining text through the parser
      parsed_paren_text = Ingreedy.parse(reparse_text)
      # use the text outside the parens as the ingredient name and the unit
      # and quantity from within the parens
      stripped_parens_text = ingredient_text.gsub(/\(.*?\)/, "").strip
      Ingreedy::Parser::Result.new(
        parsed_paren_text.amount,
        parsed_paren_text.unit,
        parsed_paren_text.amount,
        parsed_paren_text.unit,
        stripped_parens_text,
        ingredient_text
      )
    end
  end
end
