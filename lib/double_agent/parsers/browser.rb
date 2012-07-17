module DoubleAgent
  module Parsers
    # Each browser in BROWSER_DATA gets its own BrowserParser object. These 
    # parser objects are then used to parse specific data out of a user agent string.
    class Browser
      BLANK = '' # :nodoc:
      # The browser name as a symbol
      attr_reader :sym
      # The browser family name as a symbol
      attr_reader :family_sym

      # Instantiate a new BrowserParser using a "browser family" element from BROWSER_DATA
      def initialize(attrs={})
        @sym = attrs[:sym]
        @family_sym = attrs[:family_sym] || @sym
        @name = attrs[:name]
        if attrs[:version]
          @version = Regexp.new(attrs[:version], Regexp::IGNORECASE)
        end
      end

      # Returns the browser's name. If you provide a user agent string as an argument,
      # it will attempt to also return the major version number. E.g. "Firefox 4".
      def browser(ua=nil)
        if ua and @version
          @name % version(ua)
        else
          (@name % BLANK).rstrip
        end
      end

      # Returns the BrowserParser for this BrowserParser object's Family. E.g. the Chrome 
      # BrowserParser would return the Chromium BrowserParser. For browsers that are their 
      # own family (e.g. Firefox, IE) it will end up returning itself.
      def family
        BROWSERS[@family_sym]
      end
    
      private

      # Attempts to parse and return the browser's version from a user agent string. Returns
      # nil if nothing is found.
      def version(ua)
        ua.slice(@version)
      end
    end
  end
end
