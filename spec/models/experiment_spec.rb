# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Experiment do
  subject(:experiment) { described_class.create(key: 'test', value: 'test', chance: 100) }

  describe 'associations' do
    it 'can find experiments with devices' do
      device = Device.create(user: User.create!(email: Faker::Internet.email, password: SecureRandom.hex(8)))
      device.device_experiments.create(experiment:)
      expect(described_class.with_devices).to include(experiment)
    end

    it 'can find experiments without devices' do
      expect(described_class.without_devices).to include(described_class.create(key: 'test', value: 'test',
                                                                                chance: 100))
    end
  end
end
