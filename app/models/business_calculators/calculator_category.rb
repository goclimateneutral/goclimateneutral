# frozen_string_literal: true

module BusinessCalculators
  class CalculatorCategory < ApplicationRecord
    belongs_to :calculator, class_name: 'BusinessCalculators::Calculator'
    has_many :fields, class_name: 'BusinessCalculators::CalculatorField', foreign_key: 'category_id'

    validates_presence_of :name

    accepts_nested_attributes_for :fields, reject_if: proc { |attributes| attributes['label'].blank? }

    def self.model_name
      @model_name ||= ActiveModel::Name.new(self, nil, 'calculator_category')
    end
  end
end
