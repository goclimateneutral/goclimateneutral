# frozen_string_literal: true

module BusinessCalculators
  class CalculatorField < ApplicationRecord
    belongs_to :category, class_name: 'BusinessCalculators::CalculatorCategory'

    validates_presence_of :label
  end
end
