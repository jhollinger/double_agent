require 'rspec'
require File.dirname(__FILE__) + '/../lib/double_agent/parser'
require File.dirname(__FILE__) + '/../lib/double_agent/resources'
require File.dirname(__FILE__) + '/../lib/double_agent/stats'
require File.dirname(__FILE__) + '/../lib/double_agent/logs'

Rspec.configure do |c|
  c.mock_with :rspec
end

module Kernel
  def suppress_warnings
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    result = yield
    $VERBOSE = original_verbosity
    return result
  end
end
