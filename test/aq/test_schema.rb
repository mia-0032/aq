require_relative '../test_helper'
require 'aq/schema'

module Aq
  class SchemaTest < Test::Unit::TestCase
    setup do
      @schema = Schema.new
    end

    test 'ok' do
      @schema.append_column 'str0', 'string'
      @schema.append_column 'str1', 'string', 'required'
      @schema.append_column 'str2', 'string', 'nullable'
      @schema.append_column 'num',  'integer'
      @schema.append_column 'f',    'float'
      @schema.append_column 'bool', 'boolean'
      @schema.append_column 'ts',   'timestamp'
      @schema.append_column 'd',    'date'
      @schema.append_column 't',    'time'
      @schema.append_column 'dt',   'datetime'

      expected = [
        {name: 'str0', type: 'STRING'   , nullable: true },
        {name: 'str1', type: 'STRING'   , nullable: false},
        {name: 'str2', type: 'STRING'   , nullable: true },
        {name: 'num',  type: 'BIGINT'   , nullable: true },
        {name: 'f',    type: 'DOUBLE'   , nullable: true },
        {name: 'bool', type: 'BOOLEAN'  , nullable: true },
        {name: 'ts',   type: 'TIMESTAMP', nullable: true },
        {name: 'd',    type: 'DATE'     , nullable: true },
        {name: 't',    type: 'TIMESTAMP', nullable: true },
        {name: 'dt',   type: 'TIMESTAMP', nullable: true },
      ]

      assert_equal(expected, @schema.get_all)
    end

    test 'not supported type' do
      assert_raise NotSupportedError do
        @schema.append_column 'ng',  'bytes'
      end
    end

    test 'not implemented type' do
      assert_raise NotImplementedError do
        @schema.append_column 'ng',  'record'
      end
    end
  end

  class SchemaLoaderTest < Test::Unit::TestCase
    setup do
      @loader = SchemaLoader.new
    end

    test 'from file' do
      result = @loader.load('test/resource/schema.json').get_all
      expected = [
        {name: 'str0', type: 'STRING', nullable: false},
        {name: 'str1', type: 'STRING', nullable: true },
        {name: 'str2', type: 'STRING', nullable: true }
      ]
      assert_equal(expected, result)
    end

    test 'from string' do
      result = @loader.load('str0:STRING,str1:STRING,str2:STRING').get_all
      expected = [
        {name: 'str0', type: 'STRING', nullable: true},
        {name: 'str1', type: 'STRING', nullable: true },
        {name: 'str2', type: 'STRING', nullable: true }
      ]
      assert_equal(expected, result)
    end
  end
end
