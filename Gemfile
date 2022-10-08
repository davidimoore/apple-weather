source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.0"

gem "dotenv-rails", groups: [:development, :test]
gem "bootsnap", require: false
gem "bootstrap", "~> 5.2.1"
gem "importmap-rails"
gem "jbuilder"
gem "puma", "~> 5.0"
gem "redis", "~> 4.0"
gem "rails", "~> 7.0.4"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "stimulus-rails"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "turbo-rails"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rspec-rails"
end

group :development do
  gem "web-console"
end

group :test do
  gem "vcr"
  gem "webmock"
end

