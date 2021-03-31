class CreateDataReporters < ActiveRecord::Migration[6.0]
  def change
    create_table :data_reporters do |t|
      t.timestamps

      t.text :key
      t.text :email

      t.references :user, foreign_key: true
      t.references :report, null: false, foreign_key: { to_table: :climate_reports_reports }
    end
  end
end
