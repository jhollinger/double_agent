begin
  require 'gruff'
rescue LoadError
  $stderr.puts "ERROR \"gruff\" is not available; graphing module cannot be loaded"
end

module DoubleAgent
  # Extends the DoubleAgent::Stats module with chart generators. Requires the Ruby "gruff" gem.
  module Graphs
    # Adds a pie chart generating method to the ResultSet class that includes it.
    module PieChart
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
      #  DoubleAgent::Stats.percentages(logs, :browser_family).pie_chart('/path/to/browser-share.png', 'Browser Share')
      #
      # Example 2:
      #
      #  DoubleAgent::Stats.percentages(logs, :browser_family).pie_chart('/path/to/browser-share.png') do |pie|
      #    pie.title = 'Browser Share'
      #    pie.font = '/path/to/font.ttf'
      #    pie.theme = pie.theme_37signals
      #  end
      # 
      # Example 3:
      # 
      #  blog = DoubleAgent::Stats.percentages(logs, :browser_family).pie_chart.to_blob
      #
      def pie_chart(path=nil, title=nil)
        pie = Gruff::Pie.new
        pie.title = title unless title.nil?
        yield(pie) if block_given?

        each do |result|
          name = result[0..attributes.size].join(' / ')
          percent = result[attributes.size + 1]
          pie.data name, percent
        end

        pie.write(path) unless path.nil?
        pie
      end
    end

    # Adds a line graph generating method to the ResultSet class that includes it.
    module LineGraph
      # Returns a Gruff::Line object with the stats set.
      # 
      # "x_method" should be a DoubleAgent::Logs::Entry::Resource method like :date or a lambda that accepts
      # a DoubleAgent::Resource object and returns a value for the x axis.
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
      #  DoubleAgent::Stats.percentages(logs, :browser_family).line_graph(:date, '/path/to/browser-share.png', 'Browser Share')
      #
      # Example 2:
      #
      #  DoubleAgent::Stats.counts(logs, :browser).line_graph(:date, '/path/to/browser-share.png') do |chart, labeler|
      #    chart.title = 'Browser Share'
      #    chart.font = '/path/to/font.ttf'
      #    chart.theme = pie.theme_37signals
      #  end
      #
      # Example 3:
      #
      #  DoubleAgent::Stats.counts(logs, :browser_family).line_graph(:date, '/path/to/browser-share.png') do |chart, labeler|
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
      #  DoubleAgent::Stats.percentages(logs, :os_family, :browser_family).line_graph(->(l) { l.date.strftime('%m/%Y') }, '/path/to/os-browser-share.png', 'OS / Browser Share by Month')
      #
      def line_graph(x_method, path=nil, title=nil)
        chart = Gruff::Line.new
        chart.title = title unless title.nil?

        # Create an empty array for each group (e.g. {"Firefox" => [], "Safari" => []})
        data = resources.map { |r| attributes.map { |attr| r.send(attr) } }.uniq.inject({}) do |dat, attrs|
          dat[attrs] = []
          dat
        end

        # Group the data on the x axis
        resources_by_x = resources.group_by(&x_method)
        for group in resources_by_x.sort_by(&:first).map(&:last)
          stats = self.class.new(group, *attributes).group_by { |result| result[0..attributes.size-1] }
          # Record how many from each group (e.g. Firefox, Safari) fall on this point of the x axis (e.g. date)
          for attrs, dat in data
            dat << (stats[attrs] ? stats[attrs][0][1] : 0)
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
        labels = resources_by_x.keys
        chart.labels = Hash[*labels.select { |x| labels.index(x) % label_every_n == 0 }.map { |x| [*labels.index(x), labeler[x]] }.flatten]

        # Add data to the chart
        data.each { |attrs, dat| chart.data attrs.join(' / '), dat }

        chart.write(path) unless path.nil?
        chart
      end
    end

    # Adds a bar graph generating method to the ResultSet class that includes it.
    module BarGraph
      def bar_graph
      end
    end
  end
end
