# frozen_string_literal: true

class ReportedDatasController < ApplicationController
  def new
    @data_request = DataRequest.where(key: params[:key]).first
    @report_area = ClimateReports::ReportArea.find(@data_request.report_area_id)
    @calculator = BusinessCalculators::Calculator.find(@report_area.calculator_id)
    @report = ClimateReports::Report.find(@report_area.report_id)

    category_fields_reported_datas(@report_area)
  end

  def create
    @data_request = DataRequest.find(reported_data_params.first[:data_request_id].values.first)
    reported_datas = create_reported_datas_from_params
    if reported_datas.all?(&:valid?)
      reported_datas.each(&:save!)
      redirect_to thank_you_reported_data_path(id: @data_request.key)
    else
      redirect_to(
        reported_datas_path(key: @data_request.key),
        notice: 'There was and error and the data could not be saved! Please try again or contact us at hello@goclimate.com' # rubocop:disable Layout/LineLength
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
    category_fields_reported_datas
  end

  private

  def reported_data_params
    @reported_data_params ||= params.require(:reported_datas).values.map do |p|
      ActionController::Parameters.new(p).permit(
        data_request_id: {},
        calculator_field_id: {},
        id: {},
        value: {},
        unit: {}
      ).to_h
    end
  end

  

  def sort_and_clean_hash(hash)
    hash.reject { |_key, value| value.blank? }.sort_by { |key, _value| key }.to_h
  end

  def clean_param(param)
    new_param = {}
    param.each_key do |key|
      cleaned_hash = sort_and_clean_hash(param[key])
      new_param[key] = cleaned_hash.values
    end
    new_param
  end

  def clean_reported_data_params(params)
    no_blank_values = params.reject { |param| param[:value].blank? || param[:value]&.values&.blank? }
    new_params = []
    no_blank_values.each do |param|
      values_with_array = param[:value].select { |_key, value| value.is_a?(Array) }
      values_with_array.values&.each do |value_array|
        value_array.each do |value|
          new_param = param.dup
          new_param[:value] = { '0' => value }
          new_params.push(clean_param(new_param))
        end
      end
      pp = param[:value].reject { |_key, value| value.is_a?(Array) }
      skip if pp.blank?
      new_param = param.dup
      new_param[:value] = pp
      new_params.push(clean_param(param))
    end
    new_params
  end

  def create_reported_datas_from_params
    reported_datas = []
    clean_reported_data_params(reported_data_params).each do |param|
      param['value'].each_with_index do |_value, index|
        reported_data = ReportedData.where(id: param['id'][index]).first_or_create
        param.each_key do |key|
          reported_data[key] = param[key][index]
        end
        reported_datas.push(reported_data)
      end
    end
    reported_datas
  end

  def category_fields_reported_datas(report_area = nil)
    @category_fields_reported_datas = @calculator.categories.map do |category|
      [
        category,
        category.fields.map { |field| field },
        set_reported_datas(category, report_area)
      ]
    end
  end

  def set_reported_datas(category, report_area) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    reported_datas = []
    category.fields.each do |field|
      data_reporter = @calculator.survey && @data_request.present? ? DataReporter.find(@data_request.recipient_id) : nil
      answers = field.answers(report_area, data_reporter)
      if answers.present? && answers.count > 0
        if @calculator.survey || field.multiple_answers
          reported_datas.push(answers.to_a)
        else
          reported_datas.push(answers.to_a.map { |answer| ReportedData.new(answer.attributes.except('id')) })
        end
        next
      end
      reported_datas.push([ReportedData.new(calculator_field: field, data_request: @data_request)])
    end
    reported_datas
  end
end
