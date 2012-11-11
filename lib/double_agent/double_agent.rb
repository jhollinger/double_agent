# A browser user agent string parser. Use DoubleAgent.parse(user_agent) to return a DoubleAgent::UserAgent object, which you can 
# query with methods like "browser_name" or "os". The DoubleAgent module itself responds to those same method - just
# pass the user agent string as an argument.
module DoubleAgent
  # A hash of browser data, the basis for browser parsing. You may edit this data and call load_browsers! to customize parsing.
  BROWSER_DATA = Psych.load_file(File.expand_path('../../../data/browsers.yml', __FILE__))

  # A hash of OS hashes, the basis for OS parsing. You may edit this data and call load_oses! to customize parsing.
  OS_DATA = Psych.load_file(File.expand_path('../../../data/oses.yml', __FILE__))

  BROWSER_PARSERS, OS_PARSERS = {}, {} # :nodoc:

  # Returns a new UserAgent object
  def self.parse(user_agent_string)
    UserAgent.new(user_agent_string)
  end

  # Mix DoubleAgent::Resource into klass. If klass doesn't already have a user_agent method,
  # you may pass a block which will be used to define one.
  def self.resource(klass, &user_agent_block)
    klass.class_eval do
      define_method :user_agent, &user_agent_block
    end if user_agent_block
    klass.send :include, DoubleAgent::Resource
  end

  # Forwards calls to a UserAgent object
  def self.method_missing(method, *args, &block)
    parse(args.first).send(method)
  end

  # Transforms BROWSER_DATA into a case statement inside of the _browser_sym method
  def self.load_browsers!
    BROWSER_PARSERS.clear.merge! Hash[BROWSER_DATA.map { |sym, data| [sym, BrowserParser.new(sym, data)] }]

    module_eval <<-CODEZ
      def self._browser_sym(user_agent)
        case user_agent.to_s
          #{BROWSER_DATA.map { |sym, data| "when %r{#{data[:regex]}}i then :\"#{sym}\"" }.join("\n")}
        end
      end
    CODEZ
  end

  # Transforms OS_DATA into a case statement inside of the _os_sym method
  def self.load_oses!
    OS_PARSERS.clear.merge! Hash[OS_DATA.map { |sym, data| [sym, OSParser.new(sym, data)] }]

    module_eval <<-CODEZ
      def self._os_sym(user_agent)
        case user_agent.to_s
          #{OS_DATA.map { |sym, data| "when %r{#{data[:regex]}}i then :\"#{sym}\"" }.join("\n")}
        end
      end
    CODEZ
  end

  private

  # Returns the correct BrowerParser for the given user agent or symbol
  def self.browser_parser(ua_or_sym)
    BROWSER_PARSERS[ua_or_sym.is_a?(Symbol) ? ua_or_sym : _browser_sym(ua_or_sym)]
  end

  # Returns the correct OSParser for the given user agent or symbol
  def self.os_parser(ua_or_sym)
    OS_PARSERS[ua_or_sym.is_a?(Symbol) ? ua_or_sym : _os_sym(ua_or_sym)]
  end
end
