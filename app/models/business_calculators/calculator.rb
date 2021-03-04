# frozen_string_literal: true

module BusinessCalculators
  class Calculator < ApplicationRecord
    has_many :categories, class_name: 'BusinessCalculators::CalculatorCategory'

    def self.model_name
      @model_name ||= ActiveModel::Name.new(self, nil, 'business_calculator')
    end
  end
end
