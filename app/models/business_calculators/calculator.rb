# frozen_string_literal: true

module BusinessCalculators
  class Calculator < ApplicationRecord
    has_many :categories, class_name: 'BusinessCalculators::CalculatorCategory', dependent: :destroy

    accepts_nested_attributes_for :categories, allow_destroy: true, reject_if:
      proc { |attributes|
        attributes['name'].blank?
      }

    validate :status_value

    after_create :set_default_status

    def self.model_name
      @model_name ||= ActiveModel::Name.new(self, nil, 'business_calculator')
    end

    def published?
      return true if status == 'published'

      false
    end

    def archived?
      return true if status == 'archived'

      false
    end

    def draft?
      return true if status == 'draft'

      false
    end

    def publish
      self.status = 'published'
      self.save
    end

    def archive
      self.status = 'archived'
      self.save
    end

    private

    def set_default_status
      self.status = 'draft' unless status.present?
    end

    def status_value
      available_options = %w[published archived draft]
      errors.add(self.status, "must be one of #{available_options.join(', ')}") unless available_options.include?(self.status) # rubocop:disable Metrics/LineLength
    end
  end
end
