# frozen_string_literal: true

require 'csv'

module Admin
  class FlightBatchController < AdminController
    def new
    end

    def create
      text = File.read(params[:csv].path)

      # removing BOM from MS Excel csv-files
      text.sub!("\xEF\xBB\xBF", '')

      @errors = []
      @unique_lookups = {}
      @emissions = 0

      CSV.parse(text).each do |line|
        origin, destination = line[0].split(';')
        origin_airport, destination_airport = airport_search(origin, destination)

        next unless @errors.empty?

        @unique_lookups[origin] = origin_airport.first.name_sv
        @unique_lookups[destination] = destination_airport.first.name_sv

        @emissions += FootprintCalculation::FlightFootprint.new(
          cabin_class: 'economy',
          segments: [
            FootprintCalculation::FlightSegment.new(
              origin: origin_airport.first.iata_code,
              destination: destination_airport.first.iata_code
            )
          ]
        ).footprint.co2e
      end
    end

    def airport_search(origin, destination)
      @errors.push("Column empty at '#{line}'") and return if origin.nil? || destination.nil?

      origin_airport = FootprintCalculation::Airport.search(origin)
      destination_airport = FootprintCalculation::Airport.search(destination)

      @errors.push("'#{origin}' not found. Please specify airport code.") if origin_airport == []
      @errors.push("'#{destination}' not found. Please specify airport code.") if destination_airport == []

      [origin_airport, destination_airport]
    end
  end
end
