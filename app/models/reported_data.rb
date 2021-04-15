# frozen_string_literal: true

class ReportedData < ApplicationRecord
  belongs_to :data_request, class_name: 'DataRequest'
  belongs_to :calculator_field, class_name: 'BusinessCalculators::CalculatorField'

  validates_presence_of :value, :unit, :data_request, :calculator_field
end
