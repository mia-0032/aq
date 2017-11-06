# -*- coding: utf-8 -*-

require 'json'

module Aq
  class NotSupportedError < StandardError; end
  class NotImplementedError < StandardError; end

  class Schema
    def initialize
      @schema = []
    end

    def append_column(name, type, mode=nil)
      nullable = mode != 'required'
      column = {name: name, type: convert_type_from_bq_to_athena(type), nullable: nullable}
      @schema.push column
    end

    def get_all
      @schema
    end

    private
    def convert_type_from_bq_to_athena(type)
=begin
      Schema correspondence table
      ----------+----------
      BQ        | Athena
      ----------+----------
      STRING    | STRING
      BYTES     | ?
      INTEGER   | INT
      FLOAT     | DOUBLE
      BOOLEAN   | BOOLEAN
      RECORD    | ARRAY or MAP
      TIMESTAMP | TIMESTAMP
      DATE      | DATE
      TIME      | TIMESTAMP
      DATETIME  | TIMESTAMP
=end
      type.upcase!
      case type
      when 'BYTES'
        raise NotSupportedError.new '`BYTES` is not supported in Athena.'
      when 'INTEGER'
        'BIGINT'
      when 'FLOAT'
        'DOUBLE'
      when 'RECORD'
        raise NotImplementedError.new 'Sorry, `RECORD` is not supported yet in aq.'
      when 'TIME', 'DATETIME'
        'TIMESTAMP'
      else
        type
      end
    end
  end

  class SchemaLoader
    def load(schema)
      if File.exist? File.expand_path(schema)
        load_from_file File.expand_path(schema)
      else
        load_from_string schema
      end
    end

    private
    def load_from_file(file_path)
      schema = Schema.new
      JSON.load(File.open(file_path).read).each do |c|
        if c.has_key? 'mode'
          schema.append_column c['name'], c['type'], c['mode']
        else
          schema.append_column c['name'], c['type']
        end
      end
      schema
    end

    def load_from_string(str)
      schema = Schema.new
      str.split(',').each do |column|
        c = column.split(':')
        schema.append_column c[0], c[1]
      end
      schema
    end
  end
end
