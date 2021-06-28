# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    @total_users = User.count
    @total_carbon_offset = OffsettingStatistics.new.total_sold.tonnes.round
    @latest_project = Project.order(date_bought: :desc).first

    return unless ENV['INSTAGRAM_ACCESS_TOKEN']

    instagram_response = Faraday.get(
      "https://graph.instagram.com/me/media?access_token=#{ENV['INSTAGRAM_ACCESS_TOKEN']}"
    )
    @instagram_images = JSON.parse(instagram_response.body)['data'][0, 5].map do |item|
      JSON.parse(
        Faraday.get(
          "https://graph.instagram.com/#{item['id']}?fields=media_url,timestamp,permalink&access_token=#{ENV['INSTAGRAM_ACCESS_TOKEN']}" # rubocop:disable Layout/LineLength
        ).body
      )
    end
  end
end
