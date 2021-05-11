# frozen_string_literal: true

module Admin
  class ReportedDatasController < AdminController
    before_action :set_reported_data, only: [:show, :destroy]
    before_action :set_report, only: [:index, :export_to_csv]
    before_action :set_report_area, only: [:index, :export_to_csv]

    def index
      @reported_datas = format_data(reported_datas)
    end

    def show
      @calculator_field = BusinessCalculators::CalculatorField.find(@reported_data.calculator_field_id)
      data_request = DataRequest.find(@reported_data.data_request_id)
      @report = ClimateReports::ReportArea.find(data_request.report_area_id).report
      @data_reporter = DataReporter.find(data_request.recipient_id)
    end

    def destroy
      @reported_data.destroy

      redirect_to admin_reported_datas_url, notice: 'Reported data was successfully destroyed.'
    end

    def export_to_csv
      require 'csv'

      csv_file = CSV.generate do |csv|
        csv << %w[report_area question value unit latest_update report reported_data_id report_area_id report_id]
        format_data(reported_datas).each do |data|
          csv << [
            data[:report_area].title,
            data[:calculator_field].label,
            data[:reported_data].value,
            data[:reported_data].unit,
            data[:reported_data].updated_at,
            data[:report].title,
            data[:reported_data].id,
            data[:report_area].id,
            data[:report].id
          ]
        end
      end

      send_data(csv_file, filename: 'reported_data.csv', disposition: 'attachment')
    end

    private

    def set_reported_data
      @reported_data = ReportedData.find(params[:id])
    end

    def set_report
      @report = ClimateReports::Report.find(params[:report_id]) if params[:report_id]
    end

    def set_report_area
      @report_area = ClimateReports::ReportArea.find(params[:report_area_id]) if params[:report_area_id]
    end

    def reported_datas
      if @report_area
        ReportedData.all_latest_from_report_area(@report_area)
      elsif @report
        ReportedData.all_latest_from_report(@report)
      else
        ReportedData.all
      end
    end

    def format_data(data)
      data.map do |reported_data|
        data_request = DataRequest.find(reported_data.data_request_id)
        report_area = @report_area || ClimateReports::ReportArea.find(data_request.report_area_id)
        report = @report || report_area.report
        calculator_field = BusinessCalculators::CalculatorField.find(reported_data.calculator_field_id)
        {
          reported_data: reported_data,
          report_area: report_area,
          report: report,
          calculator_field: calculator_field
        }
      end
    end
  end
end
