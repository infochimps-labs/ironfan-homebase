source "http://rubygems.org"

#
# Chef
#

gem 'ironfan',         "~> 4.12.2"
gem 'chef',            "~> 11.6.0"
gem 'berkshelf',       "~> 2.0.10" 

# Yet again json versioning gets you, now with Berkshelf
# https://github.com/RiotGames/berkshelf/issues/676
# This can hopefully be unpinned from being so specific with future
# berkshelf or Chef 11 udpates. R. Berger Oct 7, 2013
gem 'json',            "1.7.7" 

gem 'parseconfig'

#
# Test drivers
#

group :test do
  gem 'rake'
  gem 'bundler',       "~> 1"
  gem 'rspec',         "~> 2.5"
  gem 'redcarpet',   "~> 2"
  gem 'cucumber',      "~> 1.1"
end

#
# Development
#

group :development do
  gem 'yard',          "~> 0.6"
  gem 'jeweler'

  gem 'ruby_gntp'

  # FIXME: Commented out until guard-chef stops breaking bundle update
  # gem 'guard',         "~> 1"
  # gem 'guard-process', "~> 1"
  # gem 'guard-chef',    :git => 'git://github.com/infochimps-forks/guard-chef.git'
  # gem 'guard-cucumber'
end

group :support do
  gem 'pry'  # useful in debugging
end
