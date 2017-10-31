# -*- coding: utf-8 -*-

require 'date'
require 'thor'

require 'aq/query'
require 'aq/query_builder'
require 'aq/schema'
require 'aq/version'

module Aq
  class AqCmd < Thor
    package_name 'aq'

    desc "ls [DATABASE]", "Show databases or tables in specified database"
    option :bucket, desc: 'S3 bucket where the query result is stored.', required: true
    option :object_prefix, desc: 'S3 object prefix where the query result is stored. Default is `Unsaved/%Y/%m/%d`'
    def ls(database=nil)
      query = QueryBuilder.ls database
      object_prefix = options[:object_prefix] || "Unsaved/#{Date.today.strftime("%Y/%m/%d")}"
      Aq::Query.new(options[:bucket], object_prefix).run(query)
    end

    desc "query QUERY", "Run the query"
    option :bucket, desc: 'S3 bucket where the query result is stored.', required: true
    option :object_prefix, desc: 'S3 object prefix where the query result is stored. Default is `Unsaved/%Y/%m/%d`'
    option :timeout, desc: 'Wait for execution of the query for this number of seconds', default: nil, type: :numeric
    def query(query)
      object_prefix = options[:object_prefix] || "Unsaved/#{Date.today.strftime("%Y/%m/%d")}"
      Aq::Query.new(options[:bucket], object_prefix).run(query, options[:timeout])
    end

    desc "version", "Print the version"
    def version
      puts "aq v#{Aq::VERSION}"
    end
  end
end
