# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Device do
  subject(:device_without_user) { described_class.create }

  let(:device_with_user) do
    described_class.create(user: User.create!(email: Faker::Internet.email, password: SecureRandom.hex(8)))
  end

  describe 'associations' do
    it 'can find devices with users' do
      expect(described_class.with_user).to include(device_with_user)
    end

    it 'can find devices without users' do
      expect(described_class.with_user).not_to include(device_without_user)
    end

    it 'can find devices with experiments' do
      Experiment.create(key: 'test', value: 'test', chance: 100)
      expect(described_class.with_experiments).to include(device_with_user)
    end

    it 'can find devices without experiments' do
      expect(described_class.with_experiments).not_to include(device_without_user)
    end
  end
end
