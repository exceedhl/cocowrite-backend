source "http://rubygems.org"

gem 'grape', '~> 0.6.0'
gem 'mysql2'
gem 'rack-fiber_pool',  :require => 'rack/fiber_pool'
gem 'activerecord', '~>3.2.8'
gem 'em-http-request'
gem 'em-synchrony', :git => 'git://github.com/igrigorik/em-synchrony.git',
                    :require => ['em-synchrony', 'em-synchrony/activerecord', 'em-synchrony/mysql2']
                            
gem 'goliath'

group :development do
  gem 'rspec'
  gem 'rspec-extra-formatters'
  gem 'guard-rspec'
  gem 'rack-test'
  gem 'webmock'
end
