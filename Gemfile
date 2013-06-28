source "http://rubygems.org"

#
# Chef
#

gem 'ironfan',         "~> 4.11.2"

gem 'berkshelf',       "= 1.4.2"     # FIXME: pins chef to the 10.16 branch.
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
