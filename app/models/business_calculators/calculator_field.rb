# frozen_string_literal: true

module BusinessCalculators
  class CalculatorField < ApplicationRecord
    belongs_to :category, class_name: 'BusinessCalculators::CalculatorCategory'

    attribute :units, :allowed_units

    validates_presence_of :label, :field_type
    validate :units_exists
    validate :correct_field_type

    def self.model_name
      @model_name ||= ActiveModel::Name.new(self, nil, 'calculator_field')
    end

    def open_ended_type?
      field_type == 'open_ended'
    end

    def survey?
      category.calculator.survey
    end

    def answers(report_area, data_reporter = nil)
      return nil unless report_area.present?

      answers = ReportedData.joins(:data_request)
                            .where('data_requests.report_area_id': report_area.id, calculator_field_id: id)
                            .order(created_at: :asc)
      answers = answers.where('data_requests.recipient_id': data_reporter.id) if data_reporter.present?
      answers = answers.reorder(created_at: :desc).limit(1) unless multiple_answers
      answers
    end

    def answers?(report_area, data_reporter = nil)
      ans = answers(report_area, data_reporter)
      ans.present? && ans.count > 0
    end

    private

    def units_exists
      return if units.nil?

      units.each_key do |key|
        errors.add(:units, 'the key can\'t  be blank') if key.blank?
        unless BusinessCalculators::Unit.exists?(key: key)
          errors.add(:units, 'the key must correspond to an existing unit')
        end
      end
    end

    def correct_field_type
      allowed_types = %w[open_ended radio checkbox]
      self.field_type = 'open_ended' unless field_type.present?
      errors.add(:field_type, "must be one of #{allowed_types.join(', ')}") unless allowed_types.include?(field_type)
    end
  end
end
