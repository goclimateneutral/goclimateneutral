class AddAlternativesToBusinessCalculatorFields < ActiveRecord::Migration[6.0]
  def change
    add_column :business_calculators_calculator_fields, :alternatives, :jsonb
  end
end
