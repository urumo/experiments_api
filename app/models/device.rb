# frozen_string_literal: true

class Device < ApplicationRecord
  belongs_to :user, optional: true
  has_many :device_experiments, dependent: :destroy, inverse_of: :device
  has_many :experiments, through: :device_experiments
  # alias experiments device_experiments

  scope :with_user, -> { where.not(user_id: nil) }
  scope :with_experiments, -> { joins(:device_experiments).distinct }

  after_create :create_device_experiments

  private

  def create_device_experiments
    Experiment.all.each do |experiment|
      device_experiments.create(experiment:)
    end
  end
end
