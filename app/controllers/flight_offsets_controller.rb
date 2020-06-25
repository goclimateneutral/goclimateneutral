# frozen_string_literal: true

class FlightOffsetsController < ApplicationController
  before_action :set_flight_footprint, only: [:new]

  def new
    @num_persons = num_persons_from_params
    @footprint_per_person = footprint_per_person

    @offset = FlightOffset.new(
      co2e: @footprint_per_person * @num_persons,
      currency: current_region.currency
    )

    @latest_projects = Project.order(date_bought: :desc).limit(3)
    @projects = Project.order(id: :desc).limit(2) # legacy
  end

  def create
    @offset = FlightOffset.new(
      params.require(:flight_offset).permit(:co2e, :currency, :email)
    )

    render_validation_errors_json && return unless @offset.valid?(:without_payment_intent_id)

    @offset.create_payment_intent
    @offset.save!

    render_payment_intent_json
  end

  def thank_you
    @offset = FlightOffset.find_by_key!(params[:key])

    render_not_found unless @offset.finalize
  end

  private

  def render_payment_intent_json
    render json: {
      payment_intent_client_secret: @offset.payment_intent.client_secret,
      success_url: thank_you_flight_offset_path(@offset)
    }
  end

  def render_validation_errors_json
    render(
      status: :bad_request,
      json: { error: { message: @offset.errors.full_messages.join(', ') } }
    )
  end

  def set_flight_footprint
    offset_params = FlightOffsetParameters.from_s(params[:offset_params])

    redirect_to(flight_footprints_path) && return if offset_params.nil?

    @flight_footprint = FootprintCalculation::FlightFootprint.new(
      cabin_class: offset_params.cabin_class,
      segments: offset_params.segments
    )
  end

  def num_persons_from_params
    (params[:num_persons].presence || 1).to_i
  end

  def footprint_per_person
    # footprint_per_person param is for partners with own co2 calculation
    # only used temporarily by flygresor.se
    return GreenhouseGases.new(params[:footprint_per_person].to_i) if params[:footprint_per_person].present?

    @flight_footprint.footprint
  end

  protected

  def canonical_query_params
    super + [:offset_params]
  end
end
