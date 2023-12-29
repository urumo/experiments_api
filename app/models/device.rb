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
      experiments: experiments.map(&:as_dto) # ideally this should be compressed with gzip and encoded in base 64
    }
  end

  after_create :assign_experiment

  private

  def assign_experiment
    Experiment.lock.transaction do
      grouped_experiments = Experiment.not_completed.order(chance: :asc).group_by(&:key)

      find_and_assign_experiment(grouped_experiments)
    end
  end

  def find_and_assign_experiment(grouped_experiments)
    grouped_experiments.each do |experiment_key, experiments_array|
      next if experiments.exists?(key: experiment_key)

      handle_experiments(experiments_array)
    end
  end

  def handle_experiments(experiments_array)
    experiments_array.each_with_index do |experiment, index|
      distribution = Distribution.find_by(key: experiment.key, value: experiment.value)
      if distribution.nil?
        device_experiments.create!(experiment:)
        break
      end

      next if distribution.percent_of_key.to_f >= experiment.chance && index != experiments_array.size - 1

      assign_random_experiment(experiments_array, experiment)
      break
    end
  end

  def assign_random_experiment(experiments_array, experiment)
    unfulfilled_experiment = Distribution.where(key: experiment.key).not_fulfilled.first&.experiment
    experiment = unfulfilled_experiment || experiments_array.sample
    device_experiments.create!(experiment:)
  end
end
