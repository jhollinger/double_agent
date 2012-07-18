require 'double_agent/stats'
require 'gruff'

module DoubleAgent
  # A collection of methods for writing Graphs from collections of objects implementing DoubleAgent::Resource.
  # You must have the Ruby "gruff" gem installed.
  module Graphs
    # Returns a Gruff::Pie object with the stats set. "objects" should be an array of DoubleAgent::Resource 
    # objects. "stat_method" should be the DoubleAgent::Resource method you wish to chart.
    #
    # Optionally you may pass a file path and graph title. If you pass a file path, the graph will
    # be written to file automatically. Otherwise, you would call "write('/path/to/graph.png')" on the
    # returned graph object.
    #
    # If you pass a block, it will be called, giving you access to the Gruff::Pie object before it is
    # written to file (that is, if you also passed a file path).
    # 
    # Example 1:
    # 
    #  logs = DoubleAgent::Logs.entries("/var/log/nginx/my-site.access.log*")
    #  DoubleAgent::Graphs.pie(logs, :browser_family, '/path/to/browser-share.png', 'Browser Share')
    #
    # Example 2:
    #
    #  DoubleAgent::Graphs.pie(logs, :browser_family, '/path/to/browser-share.png') do |pie|
    #    pie.title = 'Browser Share'
    #    pie.font = '/path/to/font.ttf'
    #    pie.theme = pie.theme_37signals
    #  end
    # 
    # Example 3:
    # 
    #  blob = DoubleAgent::Graphs.pie(logs, :browser_family).to_blob
    #
    def self.pie(objects, stat_method, path=nil, title=nil)
      pie = Gruff::Pie.new
      pie.title = title unless title.nil?
      yield(pie) if block_given?

      stats = DoubleAgent::Stats.percentages_for(objects, stat_method)
      for name, percent, count in stats
        pie.data name, percent
      end

      pie.write(path) unless path.nil?
      pie
    end

    # Returns a Gruff::Line object with the stats set. "log_entries" can be an array of anything, as long
    # as each object responds to the methods you specify in x_method and y_method. In the examples below,
    # they are DoubleAgent::Logs::Entry objects.
    # 
    # "y_method" should be a DoubleAgent::Resource method like :browser or :os
    # 
    # "x_method" should be a DoubleAgent::Logs::Entry::Resource method like :date or a lambda that accepts
    # a "log_entries" member and returns a value for the x axis.
    #
    # Optionally you may pass a file path and graph title. If you pass a file path, the graph will
    # be written to file automatically. Otherwise, you would call "write('/path/to/graph.png')" on the
    # returned graph object.
    #
    # If you pass a block, it will be called, giving you access to the Gruff::Line object before it is
    # written to file (that is, if you also passed a file path). It will also give you access to a Proc
    # for labeling the X axis.
    #
    # Example 1:
    # 
    #  logs = DoubleAgent::Logs.entries("/var/log/nginx/my-site.access.log*")
    #  DoubleAgent::Graphs.line(logs, :browser_family, :date, '/path/to/browser-share.png', 'Browser Share')
    #
    # Example 2:
    #
    #  DoubleAgent::Graphs.line(logs, :browser_family, :date, '/path/to/browser-share.png') do |chart, labeler|
    #    chart.title = 'Browser Share'
    #    chart.font = '/path/to/font.ttf'
    #    chart.theme = pie.theme_37signals
    #  end
    #
    # Example 3:
    #
    #  DoubleAgent::Graphs.line(logs, :browser_family, :date, '/path/to/browser-share.png') do |chart, labeler|
    #    chart.title = 'Browser Share'
    #
    #    # Both the 10 and the block are optional.
    #    #  - "10" means that only every 10'th label will be printed. Otherwise, each would be.
    #    #  - The block is passed each label (the return value of "x_method") and may return a formatted version.
    #    labeler.call(10) do |date|
    #      date.strftime('%m/%d/%Y')
    #    end
    #  end
    #
    # Example 4:
    #
    #  DoubleAgent::Graphs.line(logs, :browser_family, ->(e) { e.date.strftime('%m/%Y') }, '/path/to/browser-share.png', 'Browser Share by Month')
    #
    def self.line(log_entries, y_method, x_method, path=nil, title=nil)
      chart = Gruff::Line.new
      chart.title = title unless title.nil?

      data = log_entries.map(&y_method).uniq.inject({}) do |dat, name|
        dat[name] = []
        dat
      end

      # Group the data
      log_entries_by_x = log_entries.group_by(&x_method)
      for group_id, group in log_entries_by_x.sort_by(&:first)
        stats = DoubleAgent::Stats.percentages_for(group, y_method).group_by(&:first)
        for name, dat in data
          dat << (stats[name] ? stats[name][0][1] : 0)
        end
      end

      # Build the labeling proc
      label_every_n, labeler = 1, :to_s.to_proc
      get_labeler = proc do |n=1, &block|
        label_every_n = n
        labeler = block if block
      end
      yield(chart, get_labeler) if block_given?
      # Build labels and add them to chart
      labels = log_entries_by_x.keys
      chart.labels = Hash[*labels.select { |x| labels.index(x) % label_every_n == 0 }.map { |x| [*labels.index(x), labeler[x]] }.flatten]

      # Add data to the chart
      data.each { |name, dat| chart.data name, dat }

      chart.write(path) unless path.nil?
      chart
    end
  end
end
