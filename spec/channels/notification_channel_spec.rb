# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationChannel do
  let(:session_id) { SecureRandom.hex(10) }

  it 'successfully subscribes' do
    subscribe(session_id:)
    expect(subscription).to be_confirmed
  end

  it 'has stream' do
    subscribe(session_id:)
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("notification:#{session_id}")
  end

  it 'sends message' do
    subscribe(session_id:)
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from("notification:#{session_id}")
    expect do
      described_class.broadcast_to(session_id, { message: 'Hello World' })
    end.to have_broadcasted_to("notification:#{session_id}")
  end
end
