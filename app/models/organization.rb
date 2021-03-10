# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :reports, class_name: 'ClimateReports::Report'

  validates_presence_of :name
end
