class Api::LinksController < ApplicationController
  def index
    render json: Link.all.map { |link| { id: link.id.to_s, long_url: link.long_url, short_url: link.short_url } }
  end
end
