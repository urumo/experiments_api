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
      2000.times { Device.create! }
      expect(
        described_class
          .find_by(key: 'experiment_1', value: 'a')
          .percent_of_key.to_f
      ).to be_between(9, 11).inclusive
    end

    it 'has +- 33.3% actual distribution' do
      Experiment.create!(key: 'experiment_1', value: 'a', chance: 33.3)
      Experiment.create!(key: 'experiment_1', value: 'b', chance: 33.3)
      Experiment.create!(key: 'experiment_1', value: 'c', chance: 33.3)
      2000.times { Device.create! }
      expect(
        described_class
          .find_by(key: 'experiment_1', value: 'a')
          .percent_of_key.to_f
      ).to be_between(32, 35).inclusive
    end
  end
end
