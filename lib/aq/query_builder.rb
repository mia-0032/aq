require 'aq/error'

module Aq
  class QueryBuilder
    def self.ls(database)
      if database.nil?
        'SHOW DATABASES'
      else
        "SHOW TABLES IN #{database}"
      end
    end

    def self.mk(name)
      if !name.include? '.'
        "CREATE DATABASE IF NOT EXISTS #{name}"
      else
        raise InvalidParameterError.new 'Use `load` command if you create new table.'
      end
    end
  end
end
