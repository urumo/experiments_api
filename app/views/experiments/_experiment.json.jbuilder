# frozen_string_literal: true

json.extract! experiment, :id, :key, :value, :chance, :created_at, :updated_at
json.url experiment_url(experiment, format: :json)
