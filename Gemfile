source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.3'

gem 'rails-api'

gem 'pg'
gem 'sqlite3'
gem 'capistrano'
gem 'active_model_serializers'
gem 'chronic'

group :development, :test do
  gem 'pry-rails'
  gem 'brakeman'
  gem 'bundler'
  gem 'rspec-rails'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'guard-brakeman'
  case RbConfig::CONFIG["host_os"]
    when /\Adarwin/i
      gem 'terminal-notifier-guard'
      gem 'rb-fsevent'
    else
      gem 'libnotify'  
      gem 'rb-inotify'
  end
  
  gem 'rb-readline'
  
end
