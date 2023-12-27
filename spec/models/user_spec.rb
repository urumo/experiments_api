# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  subject(:user) { described_class.create!(email:, password:) }

  let(:email) { Faker::Internet.email }
  let(:password) { SecureRandom.hex(12) }

  before do
    user
  end

  describe 'validations' do
    it 'has a hashed password after being inserted into the db' do
      expect(user.password_digest).not_to be_nil
      expect(user.password_digest).not_to eq(password)
    end

    it 'cannot be created with email of invalid format' do
      user1 = described_class.new(email: 'test', password:)
      expect(user1.valid?).to be false
    end

    it 'cannot be created if email is already taken' do
      user = described_class.new(email:, password:)
      expect(user.valid?).to be false
    end
  end

  describe 'devices' do
    it 'can have multiple devices linked to it' do
      d1 = Device.create!(user:)
      d2 = Device.create!(user:)
      expect(user.devices).to include(d1, d2)
    end

    it 'cannot have device of a different user linked to it' do
      d1 = Device.create!(user:)
      d2 = Device.create!(user: described_class.create!(email: Faker::Internet.email, password: SecureRandom.hex(12)))
      expect(user.devices).to include(d1)
      expect(user.devices).not_to include(d2)
    end
  end

  describe 'scopes' do
    it 'can find a user by email' do
      expect(described_class.find_by(email:)).to eq(user)
    end

    it 'can find a user by email case insensitive' do
      expect(described_class.find_by(email: email.upcase)).to eq(user)
    end

    it 'can find all users with linked devices' do
      Device.create!(user:)
      Device.create!(user:)
      expect(described_class.with_devices).to include(user)
    end

    it 'can find all users without linked devices' do
      Device.create!(user:)
      Device.create!(user:)
      expect(described_class.without_devices).not_to include(user)
    end
  end
end
