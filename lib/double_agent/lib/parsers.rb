require 'psych'

module DoubleAgent
  # An array of "browser knowledge hashes," the basis of browser parsing. You may edit this data and call load_browsers! to customize parsing.
  BROWSER_DATA = Psych.load_file(File.expand_path('../../../../data/browsers.yml', __FILE__))

  # An array of "OS knowledge hashes," the basis of OS parsing. You may edit this data and call load_oses! to customize parsing.
  OS_DATA = Psych.load_file(File.expand_path('../../../../data/oses.yml', __FILE__))

  # An array of BrowserParser objects created from the data in BROWSER_DATA.
  BROWSERS = {}

  # An array of OSParser objects created from the data in OS_DATA.
  OSES = {}

  # Each browser in BROWSER_DATA gets its own BrowserParser object. These 
  # parser objects are then used to parse specific data out of a user agent string.
  class BrowserParser
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

  # Each OS in OS_DATA gets its own BrowserParser object. These 
  # parser objects are then used to parse specific data out of a user agent string.
  class OSParser
    attr_reader :os, :sym, :family_sym

    # Instantiate a new OSParser using an "OS family" element from OS_DATA
    def initialize(attrs={})
      @sym = attrs[:sym]
      @family_sym = attrs[:family_sym] || @sym
      @os = attrs[:name]
      @modile = attrs[:mobile] || false
    end

    # Returs true if this is mobile OS, false if not
    def mobile?
      @modile
    end

    # Returns the OSParser for this OSParser object's Family. E.g. the Ubuntu
    # OSParser would return the GNU/Linux OSerParser. For OSes that are their own
    # family (e.g. OS X) it will end up returning itself.
    def family
      OSES[@family_sym]
    end
  end

  # Parses BROWSER_DATA into BROWSERS, a hash of BrowserParser objects indexed by their symbol names.
  # Parses and evals BROWSER_DATA into a case statement inside of the browser_sym method.
  def self.load_browsers!
    BROWSERS.clear
    str = "case user_agent.to_s\n"
    BROWSER_DATA.each do |data|
      BROWSERS[data[:sym]] = BrowserParser.new(data)
      str << "  when %r{#{data[:regex]}}i then :#{data[:sym]}\n"
    end
    str << 'end'
    module_eval "def self.browser_sym(user_agent); #{str}; end"
  end

  # Parses OS_DATA into OSES, a hash of OSParser objects indexed by their symbol names.
  # Parses and evals OS_DATA into a case statement inside of the os_sym method.
  def self.load_oses!
    OSES.clear
    str = "case user_agent.to_s\n"
    OS_DATA.each do |data|
      OSES[data[:sym]] = OSParser.new(data)
      str << "  when %r{#{data[:regex]}}i then :#{data[:sym]}\n"
    end
    str << 'end'
    module_eval "def self.os_sym(user_agent); #{str}; end"
  end
end
