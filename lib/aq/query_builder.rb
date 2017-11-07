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

    def self.load(table, source, schema, source_format, patition)
      raise InvalidParameterError.new '`SOURCE` must start with "s3://"' unless source.start_with? 's3://'
      schema_state = schema.get_all.map do |s|
        "`#{s[:name]}` #{s[:type]}"
      end.join(',')
      raise InvalidParameterError.new 'Now aq support only NEWLINE_DELIMITED_JSON.' unless %w(NEWLINE_DELIMITED_JSON).include? source_format
      serde = 'org.apache.hive.hcatalog.data.JsonSerDe'
      patition_state = patition.nil? ? '' : "PARTITIONED BY (#{patition.gsub(':', ' ')})"

      <<"SQL"
CREATE EXTERNAL TABLE IF NOT EXISTS #{table} (
#{schema_state}
)
#{patition_state}
ROW FORMAT SERDE "#{serde}"
LOCATION "#{source}"
SQL
    end
  end
end
