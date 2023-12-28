# frozen_string_literal: true

class CreateDeviceExperiments < ActiveRecord::Migration[7.1]
  def change
    create_table :device_experiments, id: :uuid do |t|
      t.belongs_to :device, null: false, foreign_key: true, type: :uuid
      t.belongs_to :experiment, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
