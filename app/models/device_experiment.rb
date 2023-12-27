# frozen_string_literal: true

class DeviceExperiment < ApplicationRecord
  belongs_to :device
  belongs_to :experiment
end
