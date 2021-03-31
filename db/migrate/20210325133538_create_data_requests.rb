class CreateDataRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :data_requests do |t|
      t.timestamps

      t.references :report_area, null: false, foreign_key: { to_table: :climate_reports_report_areas }
      t.references :recipient, null: false, foreign_key: { to_table: :data_reporters }
    end
  end
end
