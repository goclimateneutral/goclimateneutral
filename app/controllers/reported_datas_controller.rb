# frozen_string_literal: true

class ReportedDatasController < ApplicationController
  def new
    @data_request = DataRequest.where(key: params[:key]).first
    @report_area = ClimateReports::ReportArea.find(@data_request.report_area_id)
    @calculator = BusinessCalculators::Calculator.find(@report_area.calculator_id)
    @report = ClimateReports::Report.find(@report_area.report_id)

    set_reported_datas
  end

  def create
    @data_request = DataRequest.find(reported_data_params.first[:data_request_id])
    reported_datas = reject_blank_values(reported_data_params).map do |param|
      reported_data = ReportedData.where(id: param[:id]).first_or_create
      reported_data.assign_attributes(param)
      reported_data
    end
    if reported_datas.all?(&:valid?)
      reported_datas.each(&:save!)
      redirect_to thank_you_reported_data_path(id: @data_request.key)
    else
      redirect_to(
        reported_datas_path(key: @data_request.key),
        notice: 'There was and error and the data could not be saved! Please try again or contact us at hello@goclimate.com' # rubocop:disable Metrics/LineLength
      )
    end
  end

  def thank_you
    @data_request = DataRequest.where(key: params[:id]).first
    @report_area = ClimateReports::ReportArea.find(@data_request.report_area_id)
    @data_reporter = DataReporter.find(@data_request.recipient_id)
  end

  def preview
    @calculator = BusinessCalculators::Calculator.find(params[:id])
    set_reported_datas
  end

  private

  def reject_blank_values(data_params)
    data_params.reject { |param| param[:value].blank? || param[:value].present? && param[:unit].blank? }
  end

  def set_reported_datas
    @reported_datas = @calculator.categories.map do |category|
      [
        category,
        category.fields.map do |field|
          @calculator.survey ? reported_data_existing_instance(field) : reported_data_new_instance(field)
        end
      ]
    end
  end

  def reported_data_params
    @reported_data_params ||= params.require(:reported_datas).values.map do |p|
      ActionController::Parameters.new(p).permit(
        :data_request_id,
        :calculator_field_id,
        :value,
        :unit,
        :id
      )
    end
  end

  def reported_data_new_instance(field)
    latest_reported_data = ReportedData.latest(@report_area, field) if @report_area
    ReportedData.new(
      calculator_field: field,
      data_request: @data_request,
      value: latest_reported_data&.value,
      unit: latest_reported_data&.unit
    )
  end

  def reported_data_existing_instance(field)
    latest_reported_data = ReportedData.latest(
      @report_area,
      field,
      DataReporter.find(@data_request.recipient_id)
    )
    latest_reported_data || ReportedData.new(
      calculator_field: field,
      data_request: @data_request
    )
  end
end
