module DoubleAgent
  # 
  # Any class with a "user_agent" method which returns a User Agent string
  # may include this module to easily parse out Browser and OS info.
  # 
  module Resource
    def browser
      _browser_parser.browser(user_agent)
    end

    def browser_sym
      _browser_parser.sym
    end

    def browser_icon
      _browser_parser.icon
    end

    def browser_family
      _browser_parser.family.browser
    end

    def browser_family_sym
      _browser_parser.family_sym
    end

    def browser_family_icon
      _browser_parser.family.icon
    end

    def os
      _os_parser.os
    end

    def os_sym
      _os_parser.sym
    end

    def os_icon
      _os_parser.icon
    end

    def os_family
      _os_parser.family.os
    end

    def os_family_sym
      _os_parser.family_sym
    end

    def os_family_icon
      _os_parser.family.icon
    end

    private

    def _browser_parser
      @browser_parser ||= DoubleAgent.browser_parser(user_agent)
    end

    def _os_parser
      @os_parser ||= DoubleAgent.os_parser(user_agent)
    end
  end
end
