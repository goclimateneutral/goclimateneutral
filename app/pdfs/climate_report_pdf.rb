# frozen_string_literal: true

class ClimateReportPdf # rubocop:disable Metrics/ClassLength
  def initialize(climate_report)
    @climate_report = climate_report
    @all_fields = @climate_report.calculation.all_fields_with_data
    @categories = @climate_report.calculation.categories
    @emissions = @climate_report.calculation.emissions
    @invoiced_climate_reports = ClimateReportInvoice.includes(climate_report: :calculation)
    @total_employees = @invoiced_climate_reports.sum(:employees)
  end

  def render # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @cover = ActionController::Base.new.render_to_string(
      template: 'pdfs/cover.html.erb',
      assigns: {
        climate_report: @climate_report
      }
    )
    WickedPdf.new.pdf_from_string(
      ApplicationController.render(
        template: 'pdfs/climate_report',
        layout: false,
        assigns: {
          climate_report: @climate_report,
          calculation_period_length: calculation_period_length,
          calculation_fields: @all_fields,
          climate_periods_to_compare: previous_climate_reports.count,
          pie_categories_data: pie_data(@categories),
          pie_sources_data: pie_data(@emissions),
          pie_scope_data: pie_scope_data,
          bar_categories_data: bar_emissions_data(@categories),
          bar_emissions_data: bar_emissions_data(@emissions),
          bar_compare_categories_data: bar_compare_data(@categories),
          bar_compare_emissions_data: bar_compare_data(@emissions),
          bar_compare_years_categories_data: bar_compare_years_data(@categories),
          bar_compare_years_emissions_data: bar_compare_years_data(@emissions),
          bar_compare_years_categories_per_employee_data: bar_compare_years_data(@categories, true),
          bar_compare_years_emissions_per_employee_data: bar_compare_years_data(@emissions, true)
        }
      ),
      footer: {
        right: 'Sida [page] av [topage]',
        left: @climate_report.company_name,
        font_name: 'sans-serif',
        font_size: 10
      },
      cover: @cover,
      orientation: 'portrait'
    )
  end

  def pie_data(fields)
    data = fields.map do |field|
      [field_name(field), field[:percentage]] unless field[:percentage] == 0
    end.compact.to_h
    { labels: "'#{data.keys.join("', '")}'", data: data.values.join(', ') }
  end

  def pie_scope_data
    data = @climate_report.calculation.even_scopes_percentages
    data.filter! { |_, v| v != 0 }
    { labels: "'#{data.keys.join("', '")}'", data: data.values.join(', ') }
  end

  def bar_emissions_data(fields)
    data = fields.map do |field|
      { field_name(field) => field[:emissions].round } unless field[:emissions] == 0
    end.compact
    {
      data: data.map { |d| d.values.join('') },
      labels: data.map { |d| d.keys.join('') }
    }
  end

  def bar_compare_data(bar_fields)
    data = []
    labels = []

    bar_fields.each do |field|
      next if field[:emissions] == 0

      labels << field_name(field) << field_average_name(field)
      data << field[:emissions].round / @climate_report.employees << (total_emissions(field) / @total_employees).round
    end
    { data: data, labels: labels }
  end

  def total_emissions(field)
    @invoiced_climate_reports.inject(0) do |n, cri|
      n + cri.climate_report.calculation.send("#{field[:name]}_emissions")
    end
  end

  def previous_climate_reports
    ClimateReport.joins(:invoice, :calculation).where(company_name: @climate_report.company_name)
  end

  def bar_compare_years_data(bar_fields, per_employee = false)
    data = []
    labels = []

    return nil if previous_climate_reports.count < 2

    bar_fields.each do |field|
      previous_climate_reports.each do |climate_report|
        emission = climate_report.calculation.send("#{field[:name]}_emissions")
        emission = BigDecimal(emission) / climate_report.employees if per_employee
        labels << "#{climate_report.calculation_period} - #{field_name(field)}"
        data << emission.round
      end
    end
    { data: data, labels: labels }
  end

  def field_name(field)
    I18n.t("business.climate_reports.#{field[:name]}")
  end

  def field_average_name(field)
    "#{I18n.t("business.climate_reports.#{field[:name]}")} - #{I18n.t('business.climate_reports.average')}"
  end

  def calculation_period_length
    length = @climate_report.calculation_period_length
    return nil if length.nil? || length == 'year'

    "(#{I18n.t("business.climate_reports.calculation_period_length_options.#{length}").downcase})"
  end
end
