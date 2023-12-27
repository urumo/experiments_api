# frozen_string_literal: true

class Experiment < ApplicationRecord
  has_many :device_experiments, dependent: :destroy, inverse_of: :experiment
  has_many :devices, through: :device_experiments
end
