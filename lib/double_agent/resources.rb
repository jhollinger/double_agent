module DoubleAgent
  # 
  # Any class with a "user_agent" method which returns a User Agent string
  # may include this module to easily parse out Browser and OS info.
  # 
  module Resource
    # Return's this object's browser name
    def browser
      _browser_parser.browser(user_agent)
    end

    # Return's this object's browser symbol name
    def browser_sym
      _browser_parser.sym
    end

    # Return's this object's browser icon name
    def browser_icon
      _browser_parser.icon
    end

    # Return's this object's browser family name
    def browser_family
      _browser_parser.family.browser
    end

    # Return's this object's browser family symbol name
    def browser_family_sym
      _browser_parser.family_sym
    end

    # Return's this object's browser family icon name
    def browser_family_icon
      _browser_parser.family.icon
    end

    # Return's this object's OS name
    def os
      _os_parser.os
    end

    # Return's this object's OS symbol name
    def os_sym
      _os_parser.sym
    end

    # Return's this object's OS icon name
    def os_icon
      _os_parser.icon
    end

    # Return's this object's OS family name
    def os_family
      _os_parser.family.os
    end

    # Return's this object's OS family symbol name
    def os_family_sym
      _os_parser.family_sym
    end

    # Return's this object's OS family icon name
    def os_family_icon
      _os_parser.family.icon
    end

    private

    # Returns and caches a BrowserParser for this object
    def _browser_parser
      @browser_parser ||= DoubleAgent.browser_parser(user_agent)
    end

    # Returns and caches an OSParser for this object
    def _os_parser
      @os_parser ||= DoubleAgent.os_parser(user_agent)
    end
  end
end
