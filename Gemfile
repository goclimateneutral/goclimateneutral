# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.6.6'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 6.0.0'
gem 'rails-i18n', '~> 6.0.0'

# Environment
gem 'bootsnap', '~> 1.3'
gem 'pg', '~> 1.0'
gem 'puma', '~> 4.2'
gem 'rack-reverse-proxy', '~> 0.12.0', require: 'rack/reverse_proxy'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Domains
gem 'countries', '~> 3.0.0'
gem 'dentaku', '~> 3.3.4'

# Authentication
gem 'devise', '~> 4.7.1'
gem 'devise-i18n', '~> 1.9.0'

# I18n
gem 'http_accept_language', '~> 2.1.1'

# Rack proxy for Webpack integration
gem 'rack-proxy', '~> 0.6.4'

# Markdown
gem 'redcarpet', '~> 3.5.0'

# Views
gem 'country_select', '~> 4.0.0'
gem 'jbuilder', '~> 2.9'

# Geometry
gem 'haversine'

# Third-party integrations
gem 'barnes' # Detailed monitoring on Heroku
gem 'intercom-rails', '~> 0.4.0'
gem 'sendgrid-actionmailer', '~> 3.0'
gem 'sentry-raven'
gem 'skylight'
gem 'stripe', '~> 5.13'

# Utilities
gem 'seed_dump', '~> 3.2'

# PDF generation
gem 'wicked_pdf', '~> 2.0'
gem 'wkhtmltopdf-binary', '0.12.4' # Later versions don't work on CircleCI
# wklhtmltopdf-binary provides binaries for Linux and macOS. If this fails you
# will have to install wkhtmltopdf manually.

gem 'meta-tags'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 3.30'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'rb-readline'
  gem 'rspec-rails', '~> 4.0'
  gem 'rspec_junit_formatter'
  gem 'rubocop', '~> 0.82.0', require: false
  gem 'rubocop-rspec', require: false
  gem 'selenium-webdriver'
end

group :development do
  gem 'brakeman'
  gem 'listen'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'guard-rubocop', require: false
  gem 'i18n-tasks', require: false
  gem 'pry-byebug' # Drop `binding.pry` anywhere you want to start debugging
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  # Locked at 0.17 until CodeClimate reporter supports 0.18
  gem 'simplecov', '~> 0.17.1', require: false
end

# If we ever want to run on Windows, tzinfo-data needs to be included because Windows does not include zoneinfo files
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
