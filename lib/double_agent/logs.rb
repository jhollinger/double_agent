require 'date'

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
      # Regex for parsing DATESTAMP_REGEXP into a Date object
      DATESTAMP_FORMAT = '%d/%B/%Y:'

      # Regex for parsing the datetime out of the log line
      TIMESTAMP_REGEXP = %r{[0-9]+/[a-z]+/[0-9]+:[0-9]+:[0-9]+:[0-9]+ (-|\+)[0-9]+}i
      # Regex for parsing TIMESTAMP_REGEXP into a DateTime object
      TIMESTAMP_FORMAT = '%d/%B/%Y:%H:%M:%S %z'

      # Initializes a new Entry object. An Apache or Nginx log line should be
      # passed to it.
      def initialize(line)
        @line = line
        @user_agent = line.slice(USER_AGENT_REGEXP)
      end

      # Returns the IP address the hit originated from
      def ip
        @line.slice(IP_REGEXP)
      end

      # Returns the Date the hit occurred on
      def on
        date_str = @line.slice(DATESTAMP_REGEXP)
        date_str ? Date.strptime(date_str, DATESTAMP_FORMAT) : nil
      end

      # Returns the DateTime the hit occurred at
      def at
        datetime_str = @line.slice(TIMESTAMP_REGEXP)
        datetime_str ? DateTime.strptime(datetime_str, TIMESTAMP_FORMAT) : nil
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
      parse = (match or ignore) \
        ? lambda { |line| entries << Entry.new(line) unless (match and line !~ match) or (ignore and line =~ ignore) } \
        : lambda { |line| entries << Entry.new(line) }

      # Define the read lambda
      read = lambda do |f|
        zipped = f =~ /\.gz\Z/i
        return unless ZLIB or not zipped
        File.open(f, 'r') do |file|
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
