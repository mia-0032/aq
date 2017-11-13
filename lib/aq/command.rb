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
    class_option :object_prefix, desc: 'S3 object prefix where the query result is stored', default: "Unsaved/#{Date.today.strftime("%Y/%m/%d")}"

    desc "ls [DATABASE]", "Show databases or tables in specified database"
    option :bucket, desc: 'S3 bucket where the query result is stored.', required: true
    def ls(database=nil)
      query = QueryBuilder.ls database
      Aq::Query.new(options[:bucket], options[:object_prefix]).run(query)
    end

    desc "mk NAME", "Create database"
    option :bucket, desc: 'S3 bucket where the query result is stored.', required: true
    def mk(name)
      query = QueryBuilder.mk name
      Aq::Query.new(options[:bucket], options[:object_prefix]).run(query)
    end

    desc "load TABLE SOURCE SCHEMA", "Create table and load data"
    option :bucket, desc: 'S3 bucket where the query result is stored.', required: true
    option :source_format, desc: 'Specify source file data format. Now aq support only NEWLINE_DELIMITED_JSON.', default: 'NEWLINE_DELIMITED_JSON'
    option :partitioning, desc: 'Specify partition key and type. ex. key1:type1,key2:type2,...', default: nil
    def load(table, source, schema)
      schema = SchemaLoader.new.load schema
      query = QueryBuilder.load table, source, schema, options[:source_format], options[:partitioning]
      Aq::Query.new(options[:bucket], options[:object_prefix]).run(query)
    end

    desc "query QUERY", "Run the query"
    option :bucket, desc: 'S3 bucket where the query result is stored.', required: true
    option :timeout, desc: 'Wait for execution of the query for this number of seconds', default: nil, type: :numeric
    def query(query)
      Aq::Query.new(options[:bucket], options[:object_prefix]).run(query, options[:timeout])
    end

    desc "version", "Print the version"
    def version
      puts "aq v#{Aq::VERSION}"
    end
  end
end
