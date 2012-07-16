begin
  require 'psych'
rescue LoadError
end
require 'yaml'

module DoubleAgent
  # An array of "browser knowledge hashes," the basis of browser parsing. You may edit this data and call load_browsers! to customize parsing.
  BROWSER_DATA = YAML.load_file(File.expand_path('../../../data/browsers.yml', __FILE__))

  # An array of "OS knowledge hashes," the basis of OS parsing. You may edit this data and call load_oses! to customize parsing.
  OS_DATA = YAML.load_file(File.expand_path('../../../data/oses.yml', __FILE__))

  # An array of BrowserParser objects created from the data in BROWSER_DATA.
  BROWSERS = {}

  # An array of OSParser objects created from the data in OS_DATA.
  OSES = {}

  # Each browser in BROWSER_DATA gets its own BrowserParser object. These 
  # parser objects are then used to parse specific data out of a user agent string.

  class BrowserParser
    BLANK = ''
    attr_reader :sym, :family_sym, :icon

    # Instantiate a new BrowserParser using a "browser family" element from BROWSER_DATA
    def initialize(attrs={})
      @sym = attrs[:sym]
      @family_sym = attrs[:family_sym] || @sym
      @name = attrs[:name]
      @icon = attrs[:icon] || @sym
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

  # Each OS in OS_DATA gets its own OSParser object. In theory, these parser
  # objects can then be used to grab further info from user agent strings, though
  # that is not currently happening.

  class OSParser
    attr_reader :os, :sym, :family_sym, :icon

    # Instantiate a new OSParser using an "OS family" element from OS_DATA
    def initialize(attrs={})
      @sym = attrs[:sym]
      @family_sym = attrs[:family_sym] || @sym
      @os = attrs[:name]
      @icon = attrs[:icon] || @sym
    end

    # Returns the OSParser for this OSParser object's Family. E.g. the Ubuntu
    # OSParser would return the GNU/Linux OSerParser. For OSes that are their own
    # family (e.g. OS X) it will end up returning itself.
    def family
      OSES[@family_sym]
    end
  end

  # Returns the browser's name, possibly including the version number, e.g. "Chrome 12"
  def self.browser(ua)
    browser_parser(ua).browser(ua)
  end

  # Returns the browser's symbol name, e.g. :chrome
  def self.browser_sym(user_agent)
    # This method is overwitten by load_browsers!
  end

  # Returns the browser's icon name, e.g. :chrome
  def self.browser_icon(ua)
    browser_parser(ua).icon
  end

  # Returns the browser's family name, e.g. "Chromium"
  def self.browser_family(ua)
    browser_parser(ua).family.browser
  end

  # Returns the browser's family's symbol name, e.g. :chromium
  def self.browser_family_sym(ua)
    browser_parser(ua).family_sym
  end

  # Returns the browser's family's icon name, e.g. :chromium
  def self.browser_family_icon(ua)
    browser_parser(ua).family.icon
  end

  # Returns the OS's name, e.g. "Ubuntu"
  def self.os(ua)
    os_parser(ua).os
  end

  # Returns the OS's symbol name, e.g. :ubuntu
  def self.os_sym(user_agent)
    # This method is overwitten by load_oses!
  end

  # Returns the OS's icon name, e.g. :ubuntu
  def self.os_icon(ua)
    os_parser(ua).icon
  end

  # Returns the OS's family, e.g. "GNU/Linux"
  def self.os_family(ua)
    os_parser(ua).family.os
  end

  # Returns the OS's family's symbol name, e.g. :linux
  def self.os_family_sym(ua)
    os_parser(ua).family_sym
  end

  # Returns the OS's family's symbol icon, e.g. :linux
  def self.os_family_icon(ua)
    os_parser(ua).family.icon
  end

  # Returns the correct BrowerParser for the given user agent or symbol
  def self.browser_parser(ua_or_sym)
    BROWSERS[ua_or_sym.is_a?(Symbol) ? ua_or_sym : browser_sym(ua_or_sym)]
  end

  # Returns the correct OSParser for the given user agent or symbol
  def self.os_parser(ua_or_sym)
    OSES[ua_or_sym.is_a?(Symbol) ? ua_or_sym : os_sym(ua_or_sym)]
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

DoubleAgent.load_browsers!
DoubleAgent.load_oses!
