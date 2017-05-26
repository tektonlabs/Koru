source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use Puma as the app server
gem 'puma', '~> 3.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use Postgres data
gem 'pg', '~> 0.20.0'

# Great Ruby dubugging companion: pretty print Ruby objects to visualize their structure.
gem 'awesome_print', '~> 1.7'

# ActiveModel::Serializers allows you to generate your JSON in an object-oriented and convention-driven manner.
gem 'active_model_serializers', '~> 0.10.5'

# Extends Rails seeds to split out complex seeds into multiple files and lets each environment have it's own seeds.
gem 'seedbank', '~> 0.4.0'

# bootstrap-sass is a Sass-powered version of Bootstrap 3, ready to drop right into your Sass powered applications.
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.7'

# Semantic UI, converted to Sass and ready to drop into Rails & Compass.
gem 'semantic-ui-sass', '~> 2.2', '>= 2.2.9.3'

# Enables easy Google map + overlays creation.
gem 'gmaps4rails', '~> 2.1', '>= 2.1.2'

# Useful to make forms and validations. It uses MaxMind database.
gem 'city-state', '~> 0.0.13'

# RailsAdmin is a Rails engine that provides an easy-to-use interface for managing your data.
gem 'rails_admin', '~> 1.1', '>= 1.1.1'

# Chart.js for use in Rails asset pipeline
gem 'chart-js-rails', '~> 0.1.2'

# Twitter typeahead packages the typeahead.js jquery plugin for rails
gem 'twitter-typeahead-rails', '~> 0.11.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production  do
  # Simple, Heroku-friendly Rails app configuration using ENV and a single YAML file
  gem 'figaro', '~> 1.1', '>= 1.1.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
