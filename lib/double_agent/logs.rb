# encoding: utf-8
require 'date'
require 'time'

module DoubleAgent
  # 
  # The Logs module contains methods and classes for parsing user agent strings
  # from Apache-style logs (includes default Nginx log format). Gzipped logs 
  # are also supported.
  # 
  module Logs
    begin
      require 'zlib'
      ZLIB = true
    rescue LoadError
      $stderr.puts "Zlib not available for DoubleAgent::Logs; gzipped log files will be skipped."
      ZLIB = false
    end

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
          time_str = @line.slice(TIMESTAMP_REGEXP).gsub(/([0-9]{4}):([0-9]{2})/, "#{$1} #{$2}") rescue nil
          @time = Time.parse(time_str) rescue nil
        end
        @time
      end
    end

    # Accepts a glob path like /var/logs/apache/my-site.access.log*,
    # parses all matching files into an array of Entry objects, and returns them.
    # Gzipped log files are parsed by Zlib.
    #
    # Options:
    # 
    # :match A regular expression. Only lines which match this will be returned.
    # :ignore A regular expression. Any lines which match this will be ignored.
    def self.entries(glob_str, options={})
      match, ignore = options[:match], options[:ignore]
      entries = []

      # Define the parse lambda
      parse = if match or ignore
        lambda { |line|
          begin
            entries << Entry.new(line) unless (match and line !~ match) or (ignore and line =~ ignore)
          rescue ArgumentError => e
            $stderr.puts "#{e.message}: #{line}"
          end
        }
      else
        lambda { |line| entries << Entry.new(line) }
      end

      # Define the read lambda
      read = lambda do |f|
        zipped = f =~ /\.gz\Z/i
        return unless ZLIB or not zipped
        File.open(f, 'r:UTF-8') do |file|
          handle = zipped ? Zlib::GzipReader.new(file) : file
          #handle.each_line &parse # A little slower, but may be more memory efficient
          handle.readlines.each &parse
        end
      end

      Dir.glob(glob_str).each &read
      entries
    end
  end
end
