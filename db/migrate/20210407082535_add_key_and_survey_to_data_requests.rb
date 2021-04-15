class AddKeyAndSurveyToDataRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :data_requests, :key, :text
    add_column :data_requests, :survey, :boolean, default: false
  end
end
