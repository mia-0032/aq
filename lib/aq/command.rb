# -*- coding: utf-8 -*-

require 'date'
require 'thor'

module Aq
  class AqCmd < Thor
    package_name 'aq'

    desc "query QUERY", "Run the query"
    option :bucket, desc: 'S3 bucket where the query result is stored.', required: true
    option :object_prefix, desc: 'S3 object prefix where the query result is stored. Default is `Unsaved/%Y/%m/%d`'
    option :timeout, desc: 'Wait for execution of the query for this number of seconds', default: nil, type: :numeric
    def query(query)
      require 'aq/query'
      object_prefix = options[:object_prefix] || "Unsaved/#{Date.today.strftime("%Y/%m/%d")}"
      Aq::Query.new(options[:bucket], object_prefix).run(query, options[:timeout])
    end

    desc "version", "Print the version"
    def version
      require 'aq/version'
      puts "aq v#{Aq::VERSION}"
    end
  end
end
