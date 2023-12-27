# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate_user!, except: %i[authenticate create_user]
  def index; end

  def authenticate; end

  def create_user; end

  def logout
    reset_session
  end
end
