require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'test/unit/rr'

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'aq'

class Test::Unit::TestCase
end
