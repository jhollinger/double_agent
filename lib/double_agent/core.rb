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
    BLANK = ''
    MIN_VERSION = '1.9.2'
    attr_reader :sym, :family_sym, :icon

    def initialize(attrs={})
      @family_sym = attrs[:family_sym]
      @name = attrs[:name]
      @sym = attrs[:sym]
      @icon = attrs[:icon] || @sym
      if RUBY_VERSION < MIN_VERSION and attrs[:safe_version]
        @safe_version = attrs[:safe_version].map { |r| Regexp.new r, Regexp::IGNORECASE }
      else
        @version = Regexp.new(attrs[:version], Regexp::IGNORECASE)
      end
    end

    def browser(ua=nil)
      if ua
        @name % version(ua)
      else
        (@name % BLANK).rstrip
      end
    end

    def icon
      @icon || @sym
    end

    def family
      BROWSERS[family_sym]
    end
    
    private

    def version(ua)
      if @safe_version and RUBY_VERSION < MIN_VERSION
        ua.slice(@safe_version[0]).slice(@safe_version[1])
      else
        ua.slice(@version)
      end
    end
  end

  class OSParser
    attr_reader :os, :sym, :family_sym, :icon

    def initialize(attrs={})
      @family_sym = attrs[:family_sym]
      @os = attrs[:name]
      @sym = attrs[:sym]
      @icon = attrs[:icon] || @sym
    end

    def family
      OSES[family_sym]
    end
  end

  # 
  # Methods for getting browser/os names, families, and icons either by passing a user agent string.
  # 

  def self.browser(ua)
    browser_parser(ua).browser(ua)
  end

  def self.browser_sym(user_agent)
  end

  def self.browser_icon(ua)
    browser_parser(ua).icon
  end

  def self.browser_family(ua)
    browser_parser(ua).family.browser
  end

  def self.browser_family_sym(ua)
    browser_parser(ua).family_sym
  end

  def self.browser_family_icon(ua)
    browser_parser(ua).family.icon
  end

  def self.os(ua)
    os_parser(ua).os
  end

  def self.os_sym(user_agent)
  end

  def self.os_icon(ua)
    os_parser(ua).icon
  end

  def self.os_family(ua)
    os_parser(ua).family.os
  end

  def self.os_family_sym(ua)
    os_parser(ua).family_sym
  end

  def self.os_family_icon(ua)
    os_parser(ua).family.icon
  end

  # Get a browser parser with either a user agent or symbol
  def self.browser_parser(ua_or_sym)
    BROWSERS[ua_or_sym.is_a?(Symbol) ? ua_or_sym : browser_sym(ua_or_sym)]
  end

  # Get an OS parser with either a user agent or symbol
  def self.os_parser(ua_or_sym)
    OSES[ua_or_sym.is_a?(Symbol) ? ua_or_sym : os_sym(ua_or_sym)]
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
