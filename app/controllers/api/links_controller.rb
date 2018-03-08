class Api::LinksController < ApplicationController
  before_action :authenticate_user_from_token!

  def index
    if user_signed_in?
      render json: jsonify(Link.where(user_id: current_user.id.to_s))
    else
      if params[:access_token].present?
        render json: {}, status: :unauthorized
      else
        render json: jsonify(Link.all)
      end
    end
  end

  private

  def jsonify(links)
    links.map { |link| { id: link.id.to_s, long_url: link.long_url, short_url: link.short_url } }
  end

  def authenticate_user_from_token!
    user = User.find_by(access_token: params[:access_token])

    sign_in user, store: false if user
  end
end
