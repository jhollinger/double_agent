module DoubleAgent
  # 
  # Any class with a "user_agent" method which returns a User Agent string
  # may include this module to easily parse out Browser and OS info.
  # 
  module Resource
    def browser_sym
      _browser_sym
    end

    def browser
      DoubleAgent.browser _browser_sym
    end

    def browser_family_sym
      DoubleAgent.browser_family_sym _browser_sym
    end

    def browser_family
      DoubleAgent.browser_family _browser_sym
    end

    def os_sym
      _os_sym
    end

    def os
      DoubleAgent.os _os_sym
    end

    def os_family_sym
      DoubleAgent.os_family_sym _os_sym
    end

    def os_family
      DoubleAgent.os_family _os_sym
    end

    private

    def _browser_sym
      @browser_sym ||= DoubleAgent.browser_sym user_agent
    end

    def _os_sym
      @os_sym ||= DoubleAgent.os_sym user_agent
    end
  end
end
