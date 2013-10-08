require "rubygems"
require "bundler/setup"
require "em-synchrony"
require "em-synchrony/activerecord"
require "grape"

$:.unshift(File.dirname(__FILE__) + '/app')

require 'yaml'
require 'erb'
CONFIG = YAML.load(ERB.new(File.read('config/settings.yml')).result)
ActiveRecord::Base.establish_connection(CONFIG['db'])



