# frozen_string_literal: true

class DataReportersController < ApplicationController
  def show
    @reporter = DataReporter.where(key: params[:id]).first
    @requests = DataRequest.where(recipient_id: @reporter.id)
  end
end
