class AddNameToLifestyleFootprint < ActiveRecord::Migration[6.0]
  def change
    add_column :lifestyle_footprints, :name, :text
  end
end
