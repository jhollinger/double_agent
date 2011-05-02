module DoubleAgent
  # 
  # For the given "things", returns the share of the group that each attr has.
  # 
  # "things" is an array of objects who's classes "include DoubleAgent::Resource".
  # 
  # "attrs" is one or more method symbols from DoubleAgent::Resource. The *_sym methods
  # are probably the most useful here, as you can use the symbol results to query DoubleAgent 
  # methods and get the browser/os name, family and icons.
  # 
  # Example, Browser Family share:
  # DoubleAgent.percentages_for(logins, :browser_family)
  # => [['Firefox', 50.4], ['Chrome', 19.6], ['Internet Explorer', 15], ['Safari', 10], ['Unknown', 5]]
  # 
  # Example, Browser/OS share, asking for symbols back:
  # DoubleAgent.percentages_for(server_log_entries, :browser_sym, :os_sym)
  # => [[:firefox_4, :windows_7, 50.4], [:firefox_3, :osx, 19.6], [:msie, :windows_xp, 15], [:safari, :osx, 10], [:other, :other, 5]]
  # 
  def self.percentages_for(things, *attrs)
    p = {}
    things.each do |h|
      syms = attrs.map { |attr| h.send attr }
      p[syms] = 0 unless p.has_key? syms
      p[syms] += 1
    end
    size = things.size.to_f
    p.to_a.collect { |k,n| [*k.<<((n * 100) / size)] }.sort { |a,b| b.last <=> a.last }
  end
end
