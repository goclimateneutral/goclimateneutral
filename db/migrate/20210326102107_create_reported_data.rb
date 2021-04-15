class CreateReportedData < ActiveRecord::Migration[6.0]
  def change
    create_table :reported_data do |t|
      t.timestamps
      
      t.text :value
      t.text :unit

      t.references :data_request, null: false, foreign_key: true
      t.references :calculator_field, null: false, foreign_key: { to_table: :business_calculators_calculator_fields }
    end
  end
end

