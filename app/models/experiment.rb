# frozen_string_literal: true

class Experiment < ApplicationRecord
  has_many :device_experiments, dependent: :destroy, inverse_of: :experiment
  has_many :devices, through: :device_experiments

  scope :with_devices, -> { joins(:device_experiments).distinct }
  scope :without_devices, -> { where.missing(:device_experiments) }
  scope :not_completed, -> { where(completed: false) }
  scope :completed, -> { where(completed: true) }

  def as_dto
    {
      key:,
      value:
    }
  end
end
