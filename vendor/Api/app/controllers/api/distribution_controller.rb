module Api
  class DistributionController < ApplicationController
    def index
      raise DeviceTokenMissingError
    end
  end
end
