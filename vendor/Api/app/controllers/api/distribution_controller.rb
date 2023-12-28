module Api
  class DistributionController < ApplicationController
    def index
      render json: { device: device.as_dto }, status: :ok
    end
  end
end
