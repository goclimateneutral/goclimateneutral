# frozen_string_literal: true

module BusinessCalculators
  class Calculator < ApplicationRecord
    has_many :categories, class_name: 'BusinessCalculators::CalculatorCategory'

    accepts_nested_attributes_for :categories, reject_if: proc { |attributes| attributes['name'].blank? }

    def self.model_name
      @model_name ||= ActiveModel::Name.new(self, nil, 'business_calculator')
    end
  end
end
