module DoubleAgent
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
  # "things" is an array of objects who's classes "include DoubleAgent::Resource".
  # "args" is one or more method symbols from DoubleAgent::Resource.
  # "args" may have, as it's last member, :threshold => n, where n is the lowest
  # percentage you want returned.
  # 
  # Example, Browser Family share:
  # DoubleAgent.percentages_for(logins, :browser_family)
  #   [['Firefox', 50.4], ['Chrome', 19.6], ['Internet Explorer', 15], ['Safari', 10], ['Unknown', 5]]
  # 
  # Example, Browser/OS share, asking for symbols back:
  # DoubleAgent.percentages_for(server_log_entries, :browser_sym, :os_sym)
  #   [[:firefox, :windows_7, 50.4], [:chrome, :osx, 19.6], [:msie, :windows_xp, 15], [:safari, :osx, 10], [:other, :other, 5]]
  def self.percentages_for(things, *args)
    options = args.last.is_a?(Hash) ? args.pop : {} # Break out options
    p = {}
    things.each do |h|
      syms = args.map { |attr| h.send attr }
      p[syms] = 0 unless p.has_key? syms
      p[syms] += 1
    end
    size = things.size.to_f
    p = p.to_a
    if BAD_RUBY
      p.collect! { |k,n| [*k.<<(better_round(((n * 100) / size), 2))] }
    else
      p.collect! { |k,n| [*k.<<(((n * 100) / size).round(2))] }
    end
    p.sort! { |a,b| b.last <=> a.last }
    p.reject! { |a| a.last < options[:threshold] } if options[:threshold]
    p
  end
end
