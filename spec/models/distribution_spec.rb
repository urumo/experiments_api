# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Distribution do
  describe 'distribution' do
    it 'has +- 10% actual distribution' do
      Experiment.create!(key: 'experiment_1', value: 'a', chance: 10)
      Experiment.create!(key: 'experiment_1', value: 'b', chance: 10)
      Experiment.create!(key: 'experiment_1', value: 'c', chance: 10)
      Experiment.create!(key: 'experiment_1', value: 'd', chance: 10)
      Experiment.create!(key: 'experiment_1', value: 'e', chance: 10)
      Experiment.create!(key: 'experiment_1', value: 'f', chance: 10)
      Experiment.create!(key: 'experiment_1', value: 'g', chance: 10)
      Experiment.create!(key: 'experiment_1', value: 'h', chance: 10)
      Experiment.create!(key: 'experiment_1', value: 'i', chance: 10)
      Experiment.create!(key: 'experiment_1', value: 'j', chance: 10)
      6000.times { Device.create! }
      expect(
        described_class
          .find_by(key: 'experiment_1', value: 'a')
          .actual_percent.to_f
      ).to be_between(9.5, 10.5).inclusive
    end

    it 'has +- 33.3% actual distribution' do
      Experiment.create!(key: 'experiment_1', value: 'a', chance: 33.3)
      Experiment.create!(key: 'experiment_1', value: 'b', chance: 33.3)
      Experiment.create!(key: 'experiment_1', value: 'c', chance: 33.3)
      6000.times { Device.create! }
      expect(
        described_class
          .find_by(key: 'experiment_1', value: 'a')
          .actual_percent.to_f
      ).to be_between(32.5, 34.5).inclusive
    end
  end
end
