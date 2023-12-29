# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.create!(email: 'admin@email.com', password: 'P@ssw0rd', role: :admin)
User.create!(email: 'user@email.com', password: 'P@ssw0rd', role: :user)

ci_env = ENV.fetch('CI_ENV', 'development')
return if ci_env == 'github-actions'

# 500.times { Device.create! }
#
# Experiment.create!(key: 'experiment_1', value: 'a', chance: 10)
# Experiment.create!(key: 'experiment_1', value: 'b', chance: 10)
# Experiment.create!(key: 'experiment_1', value: 'c', chance: 10)
# Experiment.create!(key: 'experiment_1', value: 'd', chance: 10)
# Experiment.create!(key: 'experiment_1', value: 'e', chance: 10)
# Experiment.create!(key: 'experiment_1', value: 'f', chance: 10)
# Experiment.create!(key: 'experiment_1', value: 'g', chance: 10)
# Experiment.create!(key: 'experiment_1', value: 'h', chance: 10)
# Experiment.create!(key: 'experiment_1', value: 'i', chance: 10)
# Experiment.create!(key: 'experiment_1', value: 'j', chance: 10)
#
Experiment.create!(key: 'experiment_2', value: 'a', chance: 33.3)
Experiment.create!(key: 'experiment_2', value: 'b', chance: 33.3)
Experiment.create!(key: 'experiment_2', value: 'c', chance: 33.3)

Experiment.create!(key: 'experiment_3', value: 'a', chance: 10)
Experiment.create!(key: 'experiment_3', value: 'b', chance: 20)
Experiment.create!(key: 'experiment_3', value: 'b', chance: 30)
Experiment.create!(key: 'experiment_3', value: 'c', chance: 40)
#
# 2.times.map do
#   Thread.new do
#     Rails.logger.debug { "Creating 10_000 devices in thread #{Thread.current.object_id}" }
#     30_000.times { Device.create! }
#   end
# end.each(&:join)
