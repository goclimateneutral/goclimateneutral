# frozen_string_literal: true

module ClimateReports
  class ReportArea < ApplicationRecord
    belongs_to :report, class_name: 'ClimateReports::Report'
    belongs_to :calculator, class_name: 'BusinessCalculators::Calculator'
    has_many :data_requests
    has_many :data_reporters, through: :data_requests
    has_many :reported_data, through: :data_requests

    validates_presence_of :title

    def number_of_questions
      total = 0
      calculator&.categories&.each do |category|
        total += category.fields&.length
      end

      total
    end

    def number_of_answered_questions
      ReportedData.all_latest_from_report_area(self).length
    end
  end
end
