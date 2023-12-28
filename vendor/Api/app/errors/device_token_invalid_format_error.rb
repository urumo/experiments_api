# frozen_string_literal: true

class DeviceTokenInvalidFormatError < StandardError
  def message = "Device token is not of valid format"
end
