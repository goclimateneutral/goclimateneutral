# frozen_string_literal: true

class DataReporter < ApplicationRecord
  belongs_to :report, class_name: 'ClimateReports::Report'

  has_many :data_requests, class_name: 'DataRequest', foreign_key: 'recipient_id'
  has_many :data_survey_requests

  validates_presence_of :report

  before_validation :generate_key

  private

  def generate_key
    self.key = SecureRandom.hex(12) unless key.present?
  end
end
