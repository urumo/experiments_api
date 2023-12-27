# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:email) { Faker::Internet.email }
  let(:password) { SecureRandom.hex(12) }
  subject { described_class.create!(email: email, password: password) }

  before do
    subject
  end

  describe 'validations' do
    it 'has a hashed password after being inserted into the db' do
      expect(subject.password_digest).to_not be_nil
      expect(subject.password_digest).to_not eq(password)
    end

    it 'cannot be created with email of invalid format' do
      user = User.new(email: 'test', password:)
      expect(user.valid?).to be false
    end

    it 'cannot be created if email is already taken' do
      user = User.new(email:, password:)
      expect(user.valid?).to be false
    end
  end

  describe 'devices' do


    it 'can have multiple devices linked to it' do
      d1 = Device.create!(user: subject)
      d2 = Device.create!(user: subject)
      expect(subject.devices).to include(d1, d2)
    end

    it 'cannot have device of a different user linked to it' do
      d1 = Device.create!(user: subject)
      d2 = Device.create!(user: User.create!(email: Faker::Internet.email, password: SecureRandom.hex(12)))
      expect(subject.devices).to include(d1)
      expect(subject.devices).to_not include(d2)
    end
  end

  describe 'scopes' do
    it 'can find a user by email' do
      expect(User.find_by_email(email)).to eq(subject)
    end

    it 'can find a user by email case insensitive' do
      expect(User.find_by_email(email.upcase)).to eq(subject)
    end

    it 'can find all users with linked devices' do
      d1 = Device.create!(user: subject)
      d2 = Device.create!(user: subject)
      expect(User.with_devices).to include(subject)
    end

    it 'can find all users without linked devices' do
      d1 = Device.create!(user: subject)
      d2 = Device.create!(user: subject)
      expect(User.without_devices).to_not include(subject)
    end
  end
end
