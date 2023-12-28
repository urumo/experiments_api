module Api
  class ApplicationController < ActionController::Base
    rescue_from StandardError do |exception|
      error_backtrace = Rails.env.development? || Rails.env.test? ? exception.backtrace[..5] : []
      error_message = exception.message
      error_type = exception.class
      render json: { error: { error_type:, error_message:, error_backtrace: } }, status: :internal_server_error
    end

    before_action :check_device_token

    private

    def check_device_token
      raise DeviceTokenMissingError if token.blank?
      raise DeviceTokenInvalidFormatError unless token.match?(/\h{8}-(\h{4}-){3}\h{12}/)
    end

    def device
      @device ||= ::Device.find_or_create_by!(id: token)
    end

    def token = request.headers['Device-Token'] || request.headers['device-token'] || request.headers['device_token']

  end
end
