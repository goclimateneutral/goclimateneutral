# frozen_string_literal: true

module Admin
  class ReportedDatasController < AdminController
    before_action :set_reported_data, only: [:show, :destroy]

    def index
      @report = ClimateReports::Report.find(params[:report_id]) if params[:report_id]
      @report_area = ClimateReports::ReportArea.find(params[:report_area_id]) if params[:report_area_id]

      reported_datas = if @report_area
                         ReportedData.all_latest_from_report_area(@report_area)
                       elsif @report
                         ReportedData.all_latest_from_report(@report)
                       else
                         ReportedData.all
                       end

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

    private

    def set_reported_data
      @reported_data = ReportedData.find(params[:id])
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
