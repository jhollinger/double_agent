module DoubleAgent
  # Returns a new UserAgent object
  def self.parse(user_agent_string)
    UserAgent.new(user_agent_string)
  end

  # Returns the browser's name, possibly including the version number, e.g. "Chrome 12"
  def self.browser(ua)
    parse(ua).browser
  end

  # Returns the browser's name
  def self.browser_name(ua)
    parse(ua).browser_name
  end

  # Returns the browser's name, possibly including the version number, e.g. "Chrome 12"
  def self.browser_version(ua)
    parse(ua).browser_version
  end

  # Returns the browser's symbol name, e.g. :chrome
  def self.browser_sym(user_agent)
    _browser_sym(user_agent)
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
    _os_sym(user_agent)
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
    BROWSER_PARSERS[ua_or_sym.is_a?(Symbol) ? ua_or_sym : browser_sym(ua_or_sym)]
  end

  # Returns the correct OSParser for the given user agent or symbol
  def self.os_parser(ua_or_sym)
    OS_PARSERS[ua_or_sym.is_a?(Symbol) ? ua_or_sym : os_sym(ua_or_sym)]
  end
end
