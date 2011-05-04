module DoubleAgent
  # 
  # Any class with a "user_agent" method which returns a User Agent string
  # may include this module to easily parse out Browser and OS info.
  # 
  module Resource
    def browser_sym
      _browser_parser.sym
    end

    def browser
      _browser_parser.browser
    end

    def browser_family
      _browser_parser.family
    end

    def os_sym
      _os_parser.sym
    end

    def os
      _os_parser.os
    end

    def os_family
      _os_parser.family
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
