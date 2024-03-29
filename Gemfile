source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2', '>= 5.2.2.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password

gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
 gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'haml-rails', '~> 2.0.1'
gem 'bootstrap', '~> 4.3.1'
gem 'simple_form', '~> 5.0.1'
gem 'devise', '~> 4.7.1'
gem 'rails_admin', '~> 2.0.2'
gem 'kaminari', '~> 1.2.1'
gem 'select2-rails', '~> 4.0.3'
# gem 'mysql2',          '~> 0.3'
# gem 'thinking-sphinx', '~> 4.4'
gem 'sunspot_rails', '~> 2.5.0'
gem 'pdf-reader', '~> 2.4.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'sunspot_solr', '~> 2.5.0'
  gem 'faker', '~> 2.7.0'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.1.0'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'progress_bar', '~> 1.3.0'
  gem 'brakeman'
  gem 'pry'
  gem 'pry-doc'
  gem 'method_source'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver', '~> 3.142.7'
  # Easy installation and use of chromedriver to run system tests with Chrome
   gem 'chromedriver-helper'
  # gem 'webdrivers', '~> 3.0'
end
