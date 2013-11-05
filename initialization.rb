require "rubygems"
require "bundler/setup"
require "em-synchrony"
require "em-synchrony/activerecord"
require "goliath"
require "grape"
require 'enum_accessor'

$:.unshift(File.dirname(__FILE__) + '/app')

require 'yaml'
require 'erb'
CONFIG = YAML.load(ERB.new(File.read('config/settings.yml')).result)
CONFIG['github']['client_id'] = ENV['github_client_id'] unless ENV['github_client_id'].nil?
CONFIG['github']['client_secret'] = ENV['github_client_secret'] unless ENV['github_client_secret'].nil?
ActiveRecord::Base.establish_connection(CONFIG['db'])
ActiveRecord::Base.send(:include, EnumAccessor)


