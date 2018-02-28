class Api::StatusController < ApplicationController
  def health
    render json: { "alive" => "true" }
  end
end
