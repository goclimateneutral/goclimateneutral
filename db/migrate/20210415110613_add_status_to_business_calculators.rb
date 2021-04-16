class AddStatusToBusinessCalculators < ActiveRecord::Migration[6.0]
  def change
    add_column :business_calculators_calculators, :status, :string, default: 'draft'
  end
end
