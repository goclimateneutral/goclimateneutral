# frozen_string_literal: true

class DataRequest < ApplicationRecord
  belongs_to :report_area, class_name: 'ClimateReports::ReportArea'
  belongs_to :recipient, class_name: 'DataReporter'
  has_many :reported_data

  validates_presence_of :report_area, :recipient_id
  validates :key, uniqueness: true, format: { with: /\A[a-f0-9]{40}\z/ }

  before_validation :generate_key

  private

  def generate_key
    self.key = SecureRandom.hex(20) unless key.present?
  end
end
