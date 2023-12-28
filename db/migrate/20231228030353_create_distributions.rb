# frozen_string_literal: true

class CreateDistributions < ActiveRecord::Migration[7.1]
  def change
    create_view :distributions
  end
end
