# encoding: utf-8
require 'double_agent/lib/logs'

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
