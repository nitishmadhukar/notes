# frozen_string_literal: true

# API module
module Api
  # Controller for authentication
  class AuthController < ApplicationController
    skip_before_action :authenticate_user!, only: %i[signup login]

    def signup
      user = User.new(user_params)
      if user.save
        render json: { message: 'User created successfully', email: user_params['email'] }, status: :created
      else
        render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end

    def login
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        token = JWT.encode({ user_id: user.id }, Rails.application.secrets.secret_key_base, 'HS256')
        render json: { token: }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end

    private

    def user_params
      params.permit(:email, :password)
    end
  end
end
