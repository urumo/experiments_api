module Api
  class ApplicationController < ActionController::Base
    rescue_from StandardError do |exception|
      error = [exception.class, exception.message]
      error << exception.backtrace[..5] if Rails.env.development?
      render json: { error: }, status: :internal_server_error
    end

    before_action :check_device_token

    private

    def check_device_token
      raise DeviceTokenMissingError if token.blank?
    end

    def device
      @device ||= ::Device.find_or_create_by!(id: token)
    end

    def token = request.headers['Device-Token']
  end
end
