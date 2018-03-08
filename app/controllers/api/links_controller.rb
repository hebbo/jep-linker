class Api::LinksController < ApplicationController
  before_action :authenticate_user_from_token!

  def index
    if user_signed_in?
      render json: Link
                    .where(user_id: current_user.id.to_s)
                    .map { |link| { id: link.id.to_s, long_url: link.long_url, short_url: link.short_url } }
    else
      render json: Link
                    .all
                    .map { |link| { id: link.id.to_s, long_url: link.long_url, short_url: link.short_url } }
    end
  end

  private

  # To make authentication mechanism more safe,
  # require an access_token
  def authenticate_user_from_token!

    # Use Devise.secure_compare to compare the access_token
    # in the database with the access_token given in the params.
    user = User.find_by(access_token: params[:access_token])
    if user
      # Passing store false, will not store the user in the session,
      # so an access_token is needed for every request.
      # If you want the access_token to work as a sign in token,
      # you can simply remove store: false.
      sign_in user, store: false
    end
  end
end
