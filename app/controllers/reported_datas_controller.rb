# frozen_string_literal: true

class ReportedDatasController < ApplicationController
  def new
    @data_request = DataRequest.where(key: params[:key]).first
    @report_area = ClimateReports::ReportArea.find(@data_request.report_area_id)
    @calculator = BusinessCalculators::Calculator.find(@report_area.calculator_id)

    @reported_datas = @calculator.categories.map do |category|
      [
        category,
        category.fields.map do |field|
          ReportedData.new(
            calculator_field: field,
            data_request: @data_request
          )
        end
      ]
    end
  end

  def create
    @data_request = DataRequest.find(reported_data_params.first[:data_request_id])

    reported_data_params.each do |param|
      reported_data = ReportedData.new(param)

      next if reported_data.save

      redirect_to(
        reported_datas_path(key: @data_request.key),
        notice: 'There was and error and the data could not be saved! Please try again or contact us at hello@goclimate.com' # rubocop:disable Metrics/LineLength
      )
    end

    redirect_to thank_you_reported_data_path(id: @data_request.key)
  end

  def thank_you
    @data_request = DataRequest.where(key: params[:id]).first
    @report_area = ClimateReports::ReportArea.find(@data_request.report_area_id)
    @data_reporter = DataReporter.find(@data_request.recipient_id)
  end

  private

  def reported_data_params
    params.require(:reported_datas).map do |p|
      p.permit(
        :data_request_id,
        :calculator_field_id,
        :value,
        :unit
      )
    end
  end
end
