require 'double_agent/stats'
require 'double_agent/lib/graphs'

if defined? Gruff
  module DoubleAgent
    module Stats
      class ResultSet
        include Graphs::LineGraph
        include Graphs::BarGraph
      end

      class Percentage < ResultSet
        include Graphs::PieChart
      end
    end

    module Graphs
    end
  end
end
