module DoubleAgent
  # Each browser in BROWSER_DATA gets its own BrowserParser object. These 
  # parser objects are then used to parse specific data out of a user agent string.
  class BrowserParser
    # The browser name
    attr_reader :name
    # The browser name as a symbol
    attr_reader :sym
    # The browser family name as a symbol
    attr_reader :family_sym

    # Instantiate a new BrowserParser using a "browser family" element from BROWSER_DATA
    def initialize(sym, attrs={})
      @sym = sym
      @family_sym = attrs[:family_sym] || @sym
      @name = attrs[:name]
      if attrs[:version]
        @version_pattern = Regexp.new(attrs[:version], Regexp::IGNORECASE)
      end
    end

    # Returns the browser's name. If you provide a user agent string as an argument,
    # it will attempt to also return the major version number. E.g. "Firefox 4".
    def browser(ua=nil)
      (ua and @version_pattern) ? "#{name} #{version(ua)}" : name
    end

    # Attempts to parse and return the browser's version from a user agent string. Returns
    # nil if nothing is found.
    def version(ua)
      ua.slice(@version_pattern)
    end

    # Returns the BrowserParser for this BrowserParser object's Family. E.g. the Chrome 
    # BrowserParser would return the Chromium BrowserParser. For browsers that are their 
    # own family (e.g. Firefox, IE) it will end up returning itself.
    def family
      BROWSER_PARSERS[family_sym]
    end
  end

  # Each OS in OS_DATA gets its own BrowserParser object. These 
  # parser objects are then used to parse specific data out of a user agent string.
  class OSParser
    # The operating system name
    attr_reader :os
    # The operating system name as a symbol
    attr_reader :sym
    # The operating system family name as a symbol
    attr_reader :family_sym

    # Instantiate a new OSParser using an "OS family" element from OS_DATA
    def initialize(sym, attrs={})
      @sym = sym
      @family_sym = attrs[:family_sym] || @sym
      @os = attrs[:name]
      @mobile = attrs[:mobile] || false
    end

    # Returs true if this is mobile OS, false if not
    def mobile?
      @mobile
    end

    # Returns the OSParser for this OSParser object's Family. E.g. the Ubuntu
    # OSParser would return the GNU/Linux OSerParser. For OSes that are their own
    # family (e.g. OS X) it will end up returning itself.
    def family
      OS_PARSERS[family_sym]
    end
  end
end
