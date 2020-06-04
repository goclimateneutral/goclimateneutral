# frozen_string_literal: true

class LifestyleCalculator < ApplicationRecord # rubocop:disable Metrics/ClassLength
  CATEGORIES = [:housing, :food, :car, :flights, :consumption, :public].freeze
  # TODO: house_age is unused and should be removed
  OPTION_QUESTIONS = [:region, :home, :heating, :house_age, :green_electricity, :food, :car_type].freeze
  INTEGER_QUESTIONS = [:car_distance, :flight_hours].freeze

  has_many :lifestyle_footprints

  attribute :countries, :country, array: true
  enum car_distance_unit: {
    km: 'km',
    miles: 'miles'
  }

  validates_presence_of :housing_formula, :food_formula, :car_formula, :flights_formula, :consumption_formula,
                        :public_formula, :car_distance_unit
  validate :countries_exist, :options_have_formulas, :formulas_are_well_formed

  scope :drafts, -> { where(version: nil) }
  scope :published, -> { where(<<~SQL) }
    (countries, version) IN (
      SELECT countries, MAX(version)
      FROM lifestyle_calculators
      GROUP BY countries
    )
    OR countries IS NULL AND version = (
      SELECT MAX(version) from lifestyle_calculators WHERE countries IS NULL
    )
  SQL

  def self.find_published_for_country(country)
    where(<<~SQL, country.alpha2.downcase).order(Arel.sql(<<~SQL)).first
      version IS NOT NULL AND (? = ANY(countries) OR countries IS NULL)
    SQL
      CASE WHEN countries IS NULL THEN 0 ELSE 1 END DESC, version DESC
    SQL
  end

  def self.find_or_initialize_draft_by_countries(countries)
    find_or_initialize_by(
      countries: countries&.sort,
      version: nil
    )
  end

  def calculate(answers)
    calculator = Dentaku::Calculator.new
    calculator.store(values_from_answers(answers))
    results = calculator.solve!(formulas_from_answers(answers))

    extract_categories_from_results(results).tap do |r|
      r[:total] = r.values.sum
    end
  end

  def option_keys_for_category(category)
    send("#{category}_options")&.map { |o| o['key'] }
  end

  private

  def values_from_answers(answers)
    integer_question_values = answers.slice(*INTEGER_QUESTIONS)
    answer_values = answers.slice(*OPTION_QUESTIONS).transform_keys { |k| "#{k}_answer" }

    [integer_question_values, answer_values].reduce(&:merge)
  end

  def formulas_from_answers(answers)
    option_formulas = translate_option_answers(answers.slice(*OPTION_QUESTIONS))
    category_formulas = CATEGORIES.map { |c| ["#{c}_result".to_sym, send("#{c}_formula")] }.to_h

    [option_formulas, category_formulas].reduce(&:merge)
  end

  def translate_option_answers(answers)
    answers.map do |question, answer|
      options = send("#{question}_options")
      value = options.find { |o| o['key'] == answer }['formula'] if options&.any?
      [question, value]
    end.to_h
  end

  def extract_categories_from_results(results)
    CATEGORIES.map do |category|
      [
        category,
        GreenhouseGases.new(results["#{category}_result".to_sym]&.ceil || 0)
      ]
    end.to_h
  end

  def countries_exist
    return if countries.nil?

    errors.add(:countries, 'must be either nil or not empty') if countries.empty?

    countries.any?(&:nil?) &&
      errors.add(:countries, 'countains invalid country')
  end

  def options_have_formulas # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    [
      :region_options, :home_options, :heating_options, :house_age_options, :green_electricity_options, :food_options,
      :car_type_options
    ].each do |options_field|
      options = send(options_field)

      next if options.nil?

      errors.add(options_field, 'must be either nil or not empty') if options.empty?

      options.each do |option|
        option['key'].match?(/\A[a-z_]+\z/) ||
          errors.add(options_field, "contains option with invalid key '#{option['key']}'")

        validation_calculator.ast(option['formula'])
      rescue Dentaku::TokenizerError => e
        errors.add(options_field, "contains forbidden characters for '#{option['key']}': #{e.message}")
      rescue Dentaku::ParseError => e
        errors.add(options_field, "contains invalid formula for '#{option['key']}': #{e.message}")
      end
    end
  end

  def formulas_are_well_formed
    [
      :housing_formula, :food_formula, :car_formula, :flights_formula, :consumption_formula, :public_formula
    ].each do |formula_field|
      formula = send(formula_field)
      validation_calculator.ast(formula)
    rescue Dentaku::TokenizerError => e
      errors.add(formula_field, "contains forbidden characters: #{e.message}")
    rescue Dentaku::ParseError => e
      errors.add(formula_field, "is not a valid formula: #{e.message}")
    end
  end

  def validation_calculator
    @validation_calculator ||= Dentaku::Calculator.new
  end
end
