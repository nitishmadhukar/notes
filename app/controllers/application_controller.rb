# frozen_string_literal: true

# Controller for Application
class ApplicationController < ActionController::API
  before_action :authenticate_user!

  def authenticate_user!
    headers = request.headers
    if headers['Authorization']
      token = headers['Authorization'].split(' ')[1]
      decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base)
      puts "#{decoded_token} - Decoded Token"
      payload = decoded_token.first
      @current_user = User.find(payload['user_id'])
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  rescue JWT::DecodeError
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  attr_reader :current_user
end
