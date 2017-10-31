# -*- coding: utf-8 -*-

require 'aq/base'
require 'aws-sdk-s3'
require 'csv'
require 'kosi'
require 'time'

module Aq
  class Query < Base
    def initialize(bucket, object_prefix)
      super()
      @bucket = bucket
      @object_prefix = object_prefix
    end

    def run(query, timeout=nil)
      log.info "Run Query: #{query}"

      exec_id = start_query query
      log.info "QueryExecutionID: #{exec_id}"

      timeout_time = Time.now + timeout unless timeout.nil?
      while timeout.nil? || timeout_time > Time.now
        log.debug 'Waiting query finished'
        if query_finished? exec_id
          print_result_and_exit exec_id
        end
      end

      log.error "Query:#{exec_id} is timeout. Stop query execution."
      stop_query exec_id
      exit 1
    end

    private
    def start_query(query)
      params = {
        query_string: query,
        result_configuration: {
          output_location: "s3://#{@bucket}/#{@object_prefix}"
        }
      }
      res = @client.start_query_execution(params)
      res.query_execution_id
    end

    def query_finished?(exec_id)
      res = @client.get_query_execution({query_execution_id: exec_id})
      %w(SUCCEEDED FAILED CANCELLED).include? res.query_execution.status.state
    end

    def print_result_and_exit(exec_id)
      res = @client.get_query_execution({query_execution_id: exec_id})
      case res.query_execution.status.state
      when 'SUCCEEDED'
        location = res.query_execution.result_configuration.output_location
        log.info "Query succeeded. Result: #{location}"
        print_result_file location
        exit 0
      when 'FAILED'
        log.error "Query failed. Reason: #{res.query_execution.status.state_change_reason}"
        exit 1
      when 'CANCELLED'
        log.error "Query canceled"
        exit 1
      else
        log.warn "Unknown state"
      end
    end

    def print_result_file(location)
      body = Aws::S3::Client.new.get_object(
        {bucket: @bucket, key: location.sub(/^s3:\/\/#{@bucket}\//, '')}
      ).body
      if location.end_with? '.csv'
        csv = CSV.new(body, headers: true)
        result = csv.readlines.map(&:fields)
        kosi = Kosi::Table.new({header: csv.headers})
        print kosi.render(result)
      else
        print body.read + "\n"
      end
    end

    def stop_query(exec_id)
      @client.stop_query_execution({query_execution_id: exec_id})
    end
  end
end
