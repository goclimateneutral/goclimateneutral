# frozen_string_literal: true

class LifestyleFootprintsController < ApplicationController
  def new
    (country = ISO3166::Country.new(params[:country])) &&
      (@calculator = LifestyleCalculator.find_published_for_country(country))

    render_not_found && return unless @calculator.present?

    @footprint = LifestyleFootprint.new(lifestyle_calculator: @calculator)
  end

  def create
    campaign_param = params[:lifestyle_footprint][:campaign]

    @footprint = LifestyleFootprint.new(footprint_params)
    @footprint.update_from_lifestyle_calculator
    @footprint.user = current_user
    @footprint.save!

    query_params = {
      lifestyle_footprint: @footprint
    }
    query_params[:campaign] = campaign_param unless campaign_param.blank?
    redirect_to new_registration_path(:user, **query_params)
  end

  private

  def footprint_params
    params.require(:lifestyle_footprint).permit(
      :lifestyle_calculator_id, :country, :region_answer, :home_answer,
      :heating_answer, :house_age_answer, :green_electricity_answer,
      :food_answer, :car_type_answer, :flight_hours_answer
    ).tap do |p|
      p[:car_distance_answer] = (params[:car_distance_week_answer].presence&.to_i || 0) * 52
      p[:flight_hours_answer] = 0 unless p[:flight_hours_answer].present?
    end
  end
end
