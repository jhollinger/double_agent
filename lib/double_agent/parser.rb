require 'double_agent/lib/parsers'
require 'double_agent/resources'

module DoubleAgent
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

  # Returs true if the browser appears to be on a mobile device, false if not
  def self.mobile?(ua)
    os_parser(ua).mobile?
  end

  # Returns the correct BrowerParser for the given user agent or symbol
  def self.browser_parser(ua_or_sym)
    BROWSERS[ua_or_sym.is_a?(Symbol) ? ua_or_sym : browser_sym(ua_or_sym)]
  end

  # Returns the correct OSParser for the given user agent or symbol
  def self.os_parser(ua_or_sym)
    OSES[ua_or_sym.is_a?(Symbol) ? ua_or_sym : os_sym(ua_or_sym)]
  end
end

DoubleAgent.load_browsers!
DoubleAgent.load_oses!
