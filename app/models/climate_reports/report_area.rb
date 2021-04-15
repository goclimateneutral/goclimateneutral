# frozen_string_literal: true

module ClimateReports
  class ReportArea < ApplicationRecord
    belongs_to :report, class_name: 'ClimateReports::Report'
    belongs_to :calculator, class_name: 'BusinessCalculators::Calculator'
    has_many :data_requests
    has_many :data_reporters, through: :data_requests
    has_many :reported_data, through: :data_requests

    validates_presence_of :title
  end
end
