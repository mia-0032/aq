require_relative '../test_helper'
require 'aq/error'
require 'aq/query_builder'
require 'aq/schema'

module Aq
  class QueryBuilderTest < Test::Unit::TestCase
    sub_test_case 'ls' do
      test 'show databases' do
        query = QueryBuilder.ls nil
        expected = 'SHOW DATABASES'
        assert_equal(expected, query)
      end

      test 'show tables' do
        query = QueryBuilder.ls 'my_db'
        expected = 'SHOW TABLES IN my_db'
        assert_equal(expected, query)
      end
    end

    sub_test_case 'mk' do
      test 'create database' do
        query = QueryBuilder.mk 'my_db'
        expected = 'CREATE DATABASE IF NOT EXISTS my_db'
        assert_equal(expected, query)
      end

      test 'create table' do
        assert_raise InvalidParameterError do
          QueryBuilder.mk 'my_db.my_table'
        end
      end
    end
  end
end
