module DoubleAgent
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
end
