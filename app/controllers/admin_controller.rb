# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate_user!, except: %i[authenticate create_user]

  def index; end

  def authenticate
    return unless request.post?

    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      show_notice('Invalid email or password')
    end
  end

  def create_user; end

  def create_experiment
    key = params[:key]

    params[:value].each_with_index do |value, index|
      chance = params[:chance][index]
      Experiment.create!(key:, value:, chance:)
    end

    redirect_to root_url
  rescue StandardError => e
    show_notice(e.message)
  end

  def complete_experiment
    Experiment.where(key: params[:key]).update(completed: true)
    redirect_to root_url
  rescue StandardError => e
    show_notice(e.message)
  end

  def add_test_devices
    AddTestDevicesJob.perform_later(session.id.to_s, params[:count].to_i)
    redirect_to root_url
  rescue StandardError => e
    show_notice(e.message)
  end

  def logout
    reset_session
    redirect_to root_path
  end
end
