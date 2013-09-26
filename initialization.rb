require "rubygems"
require "bundler/setup"
require "em-synchrony"
require "em-synchrony/activerecord"
require "grape"

$:.unshift(File.dirname(__FILE__) + '/app')

require 'yaml'
require 'erb'
db_config = YAML.load(ERB.new(File.read('config/database.yml')).result)
ActiveRecord::Base.establish_connection(db_config)

