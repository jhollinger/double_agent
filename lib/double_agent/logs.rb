require 'zlib'

module DoubleAgent
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

  class LogEntry
    USER_AGENT_REGEXP = /[^"]+(?="$)/
    include DoubleAgent::Resource

    attr_reader :user_agent

    def initialize(line)
      #@line = line
      @user_agent = line.slice(USER_AGENT_REGEXP)
    end
  end
end
