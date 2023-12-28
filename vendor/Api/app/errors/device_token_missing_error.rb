# frozen_string_literal: true

class DeviceTokenMissingError < StandardError
  def message = "Device token is missing"
end
