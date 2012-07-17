require 'double_agent/parsers/browser'
require 'double_agent/parsers/os'
require 'double_agent/resources'
require 'psych'

module DoubleAgent
  # An array of "browser knowledge hashes," the basis of browser parsing. You may edit this data and call load_browsers! to customize parsing.
  BROWSER_DATA = Psych.load_file(File.expand_path('../../../data/browsers.yml', __FILE__))

  # An array of "OS knowledge hashes," the basis of OS parsing. You may edit this data and call load_oses! to customize parsing.
  OS_DATA = Psych.load_file(File.expand_path('../../../data/oses.yml', __FILE__))

  # An array of BrowserParser objects created from the data in BROWSER_DATA.
  BROWSERS = {}

  # An array of OSParser objects created from the data in OS_DATA.
  OSES = {}

  # Returns a new UserAgent object
  def self.parse(user_agent_string)
    UserAgent.new(user_agent_string)
  end

  # A class representing a browser's user agent string. Various member methods parse and return browser and OS details.
  class UserAgent
    include DoubleAgent::Resource

    # The user agent string
    attr_reader :user_agent

    # Instantiate a new UserAgent object
    def initialize(user_agent_string)
      @user_agent = user_agent_string
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

  # Returns the browser's family name, e.g. "Chromium"
  def self.browser_family(ua)
    browser_parser(ua).family.browser
  end

  # Returns the browser's family's symbol name, e.g. :chromium
  def self.browser_family_sym(ua)
    browser_parser(ua).family_sym
  end

  # Returns the OS's name, e.g. "Ubuntu"
  def self.os(ua)
    os_parser(ua).os
  end

  # Returns the OS's symbol name, e.g. :ubuntu
  def self.os_sym(user_agent)
    # This method is overwitten by load_oses!
  end

  # Returns the OS's family, e.g. "GNU/Linux"
  def self.os_family(ua)
    os_parser(ua).family.os
  end

  # Returns the OS's family's symbol name, e.g. :linux
  def self.os_family_sym(ua)
    os_parser(ua).family_sym
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
      BROWSERS[data[:sym]] = Parsers::Browser.new(data)
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
      OSES[data[:sym]] = Parsers::OS.new(data)
      str << "  when %r{#{data[:regex]}}i then :#{data[:sym]}\n"
    end
    str << 'end'
    module_eval "def self.os_sym(user_agent); #{str}; end"
  end
end

DoubleAgent.load_browsers!
DoubleAgent.load_oses!
