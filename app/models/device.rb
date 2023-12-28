# frozen_string_literal: true

class Device < ApplicationRecord
  belongs_to :user, optional: true
  has_many :device_experiments, dependent: :destroy, inverse_of: :device
  has_many :experiments, through: :device_experiments

  scope :with_user, -> { where.not(user_id: nil) }
  scope :without_user, -> { where(user_id: nil) }
  scope :with_experiments, -> { joins(:device_experiments).distinct }
  scope :without_experiments, -> { where.missing(:device_experiments) }

  def as_dto
    {
      device_token: id,
      user: user&.as_dto,
      experiments: experiments.map(&:as_dto)
    }
  end

  after_create :assign_experiment

  private

  # Assigns an experiment to a device based on their chance value.
  #
  # This method selects experiments from the not_completed experiment collection
  # based on their chance value. The experiments are grouped by their keys.
  # If the device does not already have an experiment with the same key,
  # a selected experiment is created for the device.
  #
  # Returns: nil
  def assign_experiment
    # https://dev.to/jacktt/understanding-the-weighted-random-algorithm-581p#:~:text=The%20weighted%20random%20algorithm%20is,greater%20chance%20of%20being%20chosen.
    grouped_experiments = Experiment.not_completed.order(chance: :desc).group_by(&:key)
    grouped_experiments.each do |experiment_key, experiments|
      next if self.experiments.exists?(key: experiment_key)

      selected_experiment = select_experiment_based_on_chance(experiments)
      device_experiments.create(experiment: selected_experiment) if selected_experiment
    end
  end

  # Select an experiment based on their chance value.
  #
  # experiments - An Array of Experiment objects.
  #
  # Returns the selected Experiment object.
  def select_experiment_based_on_chance(experiments)
    total_chance = experiments.sum(&:chance)
    random = rand(0..total_chance)

    experiments.find do |experiment|
      random -= experiment.chance
      random <= 0
    end
  end
end
