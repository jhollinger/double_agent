require 'double_agent/lib/stats'

module DoubleAgent
  # 
  # The Stats module provides methods for determining browser and/or OS share
  # for large numbers of DoubleAgent::Resource objects.
  # 
  module Stats
    # For the given "things", returns the share of the group that each attr(s) has.
    # 
    # "things" is an array of objects who's classes mix-in DoubleAgent::Resource.
    # 
    # "args" is one or more method symbols from DoubleAgent::Resource.
    # 
    # "args" may have, as it's last member, :threshold => n, where n is the number of the lowest
    # percentage you want returned.
    # 
    # Returns an instance of DoubleAgent::Stats::Percentage, which implements Enumerable. Each member is
    # an array of [attribute(s), percentage, count]
    # 
    # Example, Browser Family share:
    # 
    # DoubleAgent::Stats.percentages(logins, :browser_family).to_a
    #   [['Firefox', 50.4, 5040], ['Chrome', 19.6, 1960], ['Internet Explorer', 15, 1500], ['Safari', 10, 1000], ['Unknown', 5, 500]]
    # 
    # Example, Browser/OS share, asking for symbols back:
    # 
    # DoubleAgent::Stats.percentages(server_log_entries, :browser_sym, :os_sym).to_a
    #   [[:firefox, :windows_7, 50.4, 5040], [:chrome, :osx, 19.6, 1960], [:msie, :windows_xp, 15, 1500], [:safari, :osx, 10, 1000], [:other, :other, 5, 100]]
    def self.percentages(things, *args)
      Percentage.new(things, *args)
    end

    # For the given "things", returns the share of the count that each attr(s) has.
    # 
    # "things" is an array of objects who's classes mix-in DoubleAgent::Resource.
    # 
    # "args" is one or more method symbols from DoubleAgent::Resource.
    # 
    # Returns an instance of DoubleAgent::Stats::Count, which implements Enumerable. Each member is
    # an array of [attribute(s), count]
    # 
    # Example, Browser Family share:
    # 
    # DoubleAgent::Stats.counts(logins, :browser_family).to_a
    #   [['Firefox', 5040], ['Chrome', 1960], ['Internet Explorer', 1500], ['Safari', 1000], ['Unknown', 500]]
    # 
    # Example, Browser/OS share, asking for symbols back:
    # 
    # DoubleAgent::Stats.counts(server_log_entries, :browser_sym, :os_sym).to_a
    #   [[:firefox, :windows_7, 50.4, 5040], [:chrome, :osx, 19.6, 1960], [:msie, :windows_xp, 15, 1500], [:safari, :osx, 10, 1000], [:other, :other, 5, 100]]
    def self.counts(things, *args)
      Count.new(things, *args)
    end
  end
end
