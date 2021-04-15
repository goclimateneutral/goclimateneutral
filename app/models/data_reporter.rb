# frozen_string_literal: true

class DataReporter < ApplicationRecord
  belongs_to :report, class_name: 'ClimateReports::Report'

  has_many :data_requests, class_name: 'DataRequest', foreign_key: 'recipient_id'

  validates_presence_of :report
  validates :key, uniqueness: true, format: { with: /\A[a-f0-9]{40}\z/ }

  before_validation :generate_key

  private

  def generate_key
    self.key = SecureRandom.hex(12) unless key.present?
  end
end
