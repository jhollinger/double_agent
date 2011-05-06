require 'zlib'

module DoubleAgent
  # Accepts a glob path like /var/logs/apache/my-site.access.log*,
  # parses all matching files into an array of LegEntry objects, and returns them.
  #
  # If a Regexp is passed as the second argument, lines which do not match
  # it will be ignored.
  def self.log_entries(glob_str, regex=nil)
    entries, gz_regexp = [], /\.gz\Z/i
    Dir.glob(glob_str).each do |f|
      File.open(f) do |file|
        handle = f =~ gz_regexp ? Zlib::GzipReader.new(file) : file
        while ( line = handle.gets )
          entries << LogEntry.new(line) if regex.nil? or line =~ regex
        end
      end
    end
    entries
  end

  # This class represents a line in an Apache or Nginx access log.
  # The user agent string is parsed out and available through the
  # user_agent attribute, making it available to the mixed-in DoubleAgent::Resource.

  class LogEntry
    # Regular expression for pulling a user agent string out of a log entry
    USER_AGENT_REGEXP = /[^"]+(?="$)/
    include DoubleAgent::Resource

    # Returns the user agent string
    attr_reader :user_agent

    # Initializes a new LogEntry object. An Apache or Nginx log line should be
    # passed to it.
    def initialize(line)
      #@line = line
      @user_agent = line.slice(USER_AGENT_REGEXP)
    end
  end
end
