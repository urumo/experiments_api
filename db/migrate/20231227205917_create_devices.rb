# frozen_string_literal: true

class CreateDevices < ActiveRecord::Migration[7.1]
  def change
    create_table :devices, id: :uuid do |t|
      t.belongs_to :user, null: true, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
