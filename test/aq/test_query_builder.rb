require_relative '../test_helper'
require 'aq/query_builder'

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
  end
end
