# encoding: utf-8
require 'date'
require 'time'

module DoubleAgent
  module Logs
    # This class represents a line in an Apache or Nginx access log.
    # The user agent string is parsed out and available through the
    # user_agent attribute, making it available to the mixed-in DoubleAgent::Resource methods.
    # Datestamps and Timestamps may also be retrieved for each instance, using the #on and #at methods, respectively.
    class Entry
      include DoubleAgent::Resource 
      # Returns the user agent string
      attr_reader :user_agent, :line

      # Regular expression for pulling a user agent string out of a log entry. It is rather imprecise
      # only for efficiency's sake.
      USER_AGENT_REGEXP = /" ".+$/

      # Regexp for parsing an IP address
      IP_REGEXP = /^[0-9a-z\.:]+/

      # Regex for parsing the date out of the log line
      DATESTAMP_REGEXP = %r{[0-9]+/[a-z]+/[0-9]+:}i

      # Regex for parsing the datetime out of the log line
      TIMESTAMP_REGEXP = %r{[0-9]+/[a-z]+/[0-9]+:[0-9]+:[0-9]+:[0-9]+ (-|\+)[0-9]+}i

      # Initializes a new Entry object. An Apache or Nginx log line should be
      # passed to it.
      def initialize(line)
        @line = line
        @user_agent = line.slice(USER_AGENT_REGEXP)
      end

      # Returns the IP address the hit originated from
      def ip
        @ip ||= @line.slice(IP_REGEXP)
      end

      # Returns the Date the hit occurred on
      def date
        @date ||= Date.parse(@line.slice(DATESTAMP_REGEXP)) rescue nil
      end

      # Returns the Time the hit occurred at
      def time
        unless @time
          time_str = @line.slice(TIMESTAMP_REGEXP).gsub(/([0-9]{4}):([0-9]{2})/, '\1 \2') rescue nil
          @time = Time.parse(time_str) rescue nil
        end
        @time
      end
    end
  end
end
