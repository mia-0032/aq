# -*- coding: utf-8 -*-

module Aq
  class QueryBuilder
    def self.ls(database)
      if database.nil?
        'SHOW DATABASES'
      else
        "SHOW TABLES IN #{database}"
      end
    end
  end
end
