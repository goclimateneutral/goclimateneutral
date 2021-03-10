# frozen_string_literal: true

module ClimateReports
  class Report < ApplicationRecord
    has_many :areas, class_name: 'ClimateReports::ReportArea'
    belongs_to :organization

    validates_presence_of :title, :reporting_period

    def self.model_name
      @model_name ||= ActiveModel::Name.new(self, nil, 'climate_report')
    end
  end
end
