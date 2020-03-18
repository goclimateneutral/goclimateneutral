# frozen_string_literal: true

class LifestyleFootprintsController < ApplicationController
  def new
    @calculator = LifestyleCalculator.find_by(countries: [ISO3166::Country.new(params[:country])])
  end

  def create
  end
end
