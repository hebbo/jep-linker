class Api::LinksController < ApplicationController
  before_action :authenticate_user_from_token!
  skip_before_action :verify_authenticity_token

  def index
    if user_signed_in?
      render json: jsonify(current_user.links)
    else
      render json: {"error" => "Unauthenticated."}, status: :unauthorized
    end
  end

  def create
    user_params = params.to_unsafe_h
    schema = Dry::Validation.Schema do
      required(:link).schema do
        required(:long_url).filled(:str?)
        optional(:short_url).filled(:str?)
      end
    end

    if user_signed_in?
      validation_messages = schema.call(user_params).messages
      if validation_messages.count == 0
        @link = Links::Builder.find_or_create(user_params[:link])
        current_user.links << @link

        if @link.valid?
          render json: { link: jsonify([@link]).first }
        else
          render json: {}, status: 500
        end

      else
        render json: validation_messages, status: 500
      end
    else
      render json: {"error" => "Unauthenticated."}, status: :unauthorized
    end
  end

  private

  def jsonify(links)
    links.map { |link| { id: link.id, short_url: link.short_url, long_url: link.long_url} }
  end

  def authenticate_user_from_token!
    token = request.headers['HTTP_AUTHORIZATION']&.split(" ")&.last
    return if token.blank?

    user = User.find_by(access_token: token)

    sign_in user, store: false if user
  end
end