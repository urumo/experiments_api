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

  def logout
    reset_session
    redirect_to root_path
  end
end
