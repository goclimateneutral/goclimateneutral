# frozen_string_literal: true

class ReportedData < ApplicationRecord
  belongs_to :data_request, class_name: 'DataRequest'
  belongs_to :calculator_field, class_name: 'BusinessCalculators::CalculatorField'

  validates_presence_of :value, :unit, :data_request, :calculator_field

  def self.latest(report_area, calculator_field)
    ReportedData
      .joins(
        <<~SQL
          INNER JOIN data_requests ON reported_data.data_request_id = data_requests.id
          INNER JOIN climate_reports_report_areas ON climate_reports_report_areas.id = data_requests.report_area_id
        SQL
      )
      .where(
        'climate_reports_report_areas.id': report_area.id,
        calculator_field_id: calculator_field.id
      )
      .order(created_at: :desc)
      .first
  end
end
