# frozen_string_literal: true

module Admin
  class ReportedDatasController < AdminController
    before_action :set_reported_data, only: [:show, :destroy]

    def index
      @reported_datas = ReportedData.all.map do |reported_data|
        data_request = DataRequest.find(reported_data.data_request_id)
        report = ClimateReports::ReportArea.find(data_request.report_area_id).report
        calculator_field = BusinessCalculators::CalculatorField.find(reported_data.calculator_field_id)
        {
          reported_data: reported_data,
          report: report,
          calculator_field: calculator_field
        }
      end
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
  end
end
