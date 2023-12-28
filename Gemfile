# frozen_string_literal: true

source 'https://rubygems.org'

ruby '> 3.0.0'

gem 'api', path: 'vendor/Api'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', require: false
gem 'jbuilder'
gem 'kredis'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.2'
gem 'redis', '>= 4.0.1'
gem 'rswag', '~> 2.13'
gem 'scenic', '~> 1.7'
gem 'sprockets-rails'
gem 'tzinfo-data', platforms: %i[windows jruby]
group :development, :test do
  gem 'debug', platforms: %i[mri windows]
  gem 'faker', '~> 3.2'
  gem 'parallel_tests', '~> 4.4'
  gem 'rspec-rails', '~> 6.1'
  gem 'rubocop', '1.57.2'
  gem 'rubocop-rails', '2.22.2'
  gem 'rubocop-rspec', '2.25.0'
end
group :development do
  gem 'rack-mini-profiler'
  gem 'spring'
  gem 'web-console'
end

gem 'rack-cors', '~> 2.0'
