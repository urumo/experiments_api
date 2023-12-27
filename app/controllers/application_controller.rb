# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user

  private

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
