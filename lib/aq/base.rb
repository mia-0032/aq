# -*- coding: utf-8 -*-

require 'aws-sdk-athena'
require 'logger'

module Aq
  class Base
    def initialize
      @client = Aws::Athena::Client.new()
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO
    end

    protected
    def log
      @logger
    end
  end
end
