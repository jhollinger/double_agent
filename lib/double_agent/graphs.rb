begin
  require 'gruff'
rescue LoadError
  $stderr.puts "ERROR \"gruff\" is not available; graphing module cannot be loaded"
end

if defined? Gruff
  require 'double_agent/stats'
  require 'double_agent/lib/graphs'

  module DoubleAgent
    module Stats
      class ResultSet
        include Graphs
      end
    end
  end
end
