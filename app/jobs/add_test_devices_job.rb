# frozen_string_literal: true

class AddTestDevicesJob < ApplicationJob
  queue_as :default

  def perform(session_id, count)
    count.times do
      Device.create!
    end
    NotificationJob.perform_later(session_id, 'Test devices added')
  end
end
