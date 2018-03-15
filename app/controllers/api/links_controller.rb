class Api::LinksController < ApplicationController
  before_action :authenticate_user_from_token!

  def index
    if user_signed_in?
      render json: jsonify(Link.where(user_id: current_user.id.to_s))
    else
      render json: {}, status: :unauthorized
    end
  end

  private

  def jsonify(links)
    links.map { |link| { id: link.id.to_s, long_url: link.long_url, short_url: link.short_url } }
  end

  def authenticate_user_from_token!
    token = request.headers['Authorization']&.split(" ")&.last
    return if token.blank?

    user = User.find_by(access_token: token)

    sign_in user, store: false if user
  end
end
