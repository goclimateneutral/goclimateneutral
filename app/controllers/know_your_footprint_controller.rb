# frozen_string_literal: true

class KnowYourFootprintController < ApplicationController
  def show
    @projects = Project.all.order(created_at: :desc).limit(3)
  end
end
