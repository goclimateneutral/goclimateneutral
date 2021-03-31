# frozen_string_literal: true

module Admin
  class DataReportersController < AdminController
    before_action :set_data_reporter, only: [:show, :edit, :update, :destroy]

    def index
      @data_reporters = DataReporter.all
    end

    def show
      @report = ClimateReports::Report.find(@data_reporter.report_id)
    end

    def new
      @data_request = DataRequest.new
      @report_area = ClimateReports::ReportArea.find(params[:area])
      @report = ClimateReports::Report.find(@report_area.report.id)
    end

    def edit
    end

    def update
      unless @data_reporter.update(data_request_params)
        render :edit
        return
      end

      redirect_to [:admin, @data_reporter], notice: 'Data reporter was successfully updated.'
    end

    def destroy
      @data_reporter.destroy

      redirect_to admin_data_reporters_url, notice: 'Data reporter was successfully destroyed.'
    end

    private

    def set_data_reporter
      @data_reporter = DataReporter.find(params[:id])
    end

    def data_request_params
      params.require(:data_reporter).permit(:email, :area)
    end
  end
end
