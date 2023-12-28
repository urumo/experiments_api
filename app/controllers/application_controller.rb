# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  add_flash_types :success, :warning, :danger, :info

  rescue_from StandardError do |exception|
    @error = [exception.class, exception.message]
    @error << exception.backtrace[..5] if Rails.env.development?
    respond_to do |format|
      format.html { render template: 'error/error', status: :internal_server_error }
      format.json do
        render json: { error: { error_type: @error.first, error_message: @error[1], error_backtrace: @error.last } },
               status: :internal_server_error
      end
    end
  end

  def change_locale
    session[:locale] = params[:locale] || I18n.default_locale
    I18n.locale = session[:locale]
    redirect_to root_path
  end

  private

  def show_notice(message)
    NotificationJob.perform_later(session.id.to_s, message)
  end

  before_action do
    year_created = '2023'
    year = Date.current.year.to_s

    @year = year == year_created ? year : "#{year_created} - #{year}"
  end

  def authenticate_user!
    return if current_user

    redirect_to authenticate_path
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
