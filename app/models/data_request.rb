# frozen_string_literal: true

class DataRequest < ApplicationRecord
  belongs_to :report_area, class_name: 'ClimateReports::ReportArea'
  belongs_to :recipient, class_name: 'DataReporter'

  validates_presence_of :report_area, :recipient_id
end
