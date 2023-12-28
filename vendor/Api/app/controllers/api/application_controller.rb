module Api
  class ApplicationController < ActionController::Base
    rescue_from StandardError do |exception|
      error = [exception.class, exception.message]
      error << exception.backtrace[..5] if Rails.env.development?
      render json: { error: }, status: :internal_server_error
    end
  end
end
