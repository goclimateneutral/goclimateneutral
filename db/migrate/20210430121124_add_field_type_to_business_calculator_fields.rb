class AddFieldTypeToBusinessCalculatorFields < ActiveRecord::Migration[6.0]
  def change
    add_column :business_calculators_calculator_fields, :field_type, :string, default: 'open_ended'
  end
end
