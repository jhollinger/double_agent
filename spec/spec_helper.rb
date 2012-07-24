require 'rspec'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib/'
require 'double_agent'

RSpec.configure do |c|
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
