# frozen_string_literal: true

class NotificationJob < ApplicationJob
  queue_as :default

  def perform(session, message)
    sleep 2 # in case a page reloads
    NotificationChannel.broadcast_to(session, message)
  end
end
