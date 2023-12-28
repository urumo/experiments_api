# frozen_string_literal: true

class NotificationChannel < ApplicationCable::Channel
  def subscribed
    Rails.logger.debug params

    stream_for params[:session_id]
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
