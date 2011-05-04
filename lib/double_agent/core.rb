require 'yaml'

module DoubleAgent
  # 
  # Map browser/os ids to names, families and icons
  # 
  BROWSER_DATA = YAML.load_file(File.expand_path('../../../data/browsers.yml', __FILE__))
  OS_DATA = YAML.load_file(File.expand_path('../../../data/oses.yml', __FILE__))

  BROWSERS = {}
  OSES = {}

  class BrowserParser
    attr_reader :family, :sym

    def initialize(attrs={})
      @family = attrs[:family]
      @name = attrs[:name]
      @sym = attrs[:sym]
      #@regex = attrs[:regex]
      @version = Regexp.new(attrs[:version], Regexp::IGNORECASE)
    end

    def browser(ua)
      @name % version(ua)
    end

    def version(ua)
      ua.slice(@version)
    end
  end

  class OSParser
    attr_reader :family, :os, :sym

    def initialize(attrs={})
      @family = attrs[:family]
      @os = attrs[:name]
      @sym = attrs[:sym]
    end
  end

  # 
  # Methods for getting browser/os names, families, and icons either by passing a user agent string.
  # 

  def self.browser(ua)
    browser_parser(ua).browser(ua)
  end

  def self.browser_family(ua)
    browser_parser(ua).family
  end

  def self.browser_icon(ua)
    browser_sym(ua)
  end

  def self.os(ua)
    os_parser(ua).os
  end

  def self.os_family(ua)
    os_parser(ua).family
  end

  def self.os_icon(ua)
    os_sym(ua)
  end

  # Get a browser parser with either a user agent or symbol
  def self.browser_parser(ua_or_sym)
    BROWSERS[ua_or_sym.is_a?(Symbol) ? ua_or_sym : browser_sym(ua_or_sym)]
  end

  # Get an OS parser with either a user agent or symbol
  def self.os_parser(ua_or_sym)
    OSES[ua_or_sym.is_a?(Symbol) ? ua_or_sym : os_sym(ua_or_sym)]
  end

  def self.browser_sym(user_agent)
  end

  def self.os_sym(user_agent)
  end

  def self.load_browsers!
    BROWSERS.clear
    str = "case user_agent\n"
    BROWSER_DATA.each do |data|
      BROWSERS[data[:sym]] = BrowserParser.new(data)
      str << "  when %r{#{data[:regex]}}i then :#{data[:sym]}\n"
    end
    str << 'end'
    module_eval "def self.browser_sym(user_agent); #{str}; end"
  end

  def self.load_oses!
    OSES.clear
    str = "case user_agent\n"
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
