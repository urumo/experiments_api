# frozen_string_literal: true

class AddCompletedToExperiments < ActiveRecord::Migration[7.1]
  def change
    add_column :experiments, :completed, :boolean, null: false, default: false
  end
end
