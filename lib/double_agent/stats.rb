module DoubleAgent
  # 
  # The Stats module provides methods for determining browser and/or OS share
  # for large numbers of DoubleAgent::Resource objects.
  # 
  module Stats
    # True if running under less than Ruby 1.9
    BAD_RUBY = RUBY_VERSION < '1.9.0'

    if BAD_RUBY
      require 'bigdecimal'
      # If BAD_RUBY, this is used in lieu of the native round method
      def self.better_round(f, n)
        d = BigDecimal.new f.to_s
        d.round(n).to_f
      end
    end

    # For the given "things", returns the share of the group that each attr has.
    # 
    # "things" is an array of objects who's classes mix-in DoubleAgent::Resource.
    # 
    # "args" is one or more method symbols from DoubleAgent::Resource.
    # 
    # "args" may have, as it's last member, :threshold => n, where n is the number of the lowest
    # percentage you want returned.
    # 
    # Returns an array of [attribute(s), percent of total, number of total]
    # 
    # Example, Browser Family share:
    # 
    # DoubleAgent::Stats.percentages_for(logins, :browser_family)
    #   [['Firefox', 50.4, 5040], ['Chrome', 19.6, 1960], ['Internet Explorer', 15, 1500], ['Safari', 10, 1000], ['Unknown', 5, 500]]
    # 
    # Example, Browser/OS share, asking for symbols back:
    # 
    # DoubleAgent::Stats.percentages_for(server_log_entries, :browser_sym, :os_sym)
    #   [[:firefox, :windows_7, 50.4, 5040], [:chrome, :osx, 19.6, 1960], [:msie, :windows_xp, 15, 1500], [:safari, :osx, 10, 1000], [:other, :other, 5, 100]]
    def self.percentages_for(things, *args)
      options = args.last.is_a?(Hash) ? args.pop : {} # Break out options
      results = {}
      # Count each instance
      things.each do |h|
        syms = args.map { |attr| h.send attr }
        results[syms] ||= 0
        results[syms] += 1
      end
      size = things.size.to_f
      results = results.to_a
      # From the total, calculate the percentage held by each browser, OS, etc.
      if BAD_RUBY
        results.collect! { |k,n| [*k.<<(better_round(((n * 100) / size), 2)).<<(n)] }
      else
        # Ruby 1.9 syntax that blows up in Ruby 1.8
        #results.collect! { |k,n| [*k, ((n * 100) / size).round(2), n] }
        results.collect! { |k,n| [*k.<<(((n * 100) / size).round(2)).<<(n)] }
      end
      # Sort in ascending order
      results.sort! { |a,b| b.last <=> a.last }
      # Reject percentages below a specified threshold
      results.reject! { |a| a[-2] < options[:threshold] } if options[:threshold]
      results
    end
  end
end
