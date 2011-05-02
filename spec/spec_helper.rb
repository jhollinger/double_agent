require 'rspec'
require File.dirname(__FILE__) + '/../lib/double_agent/core'
require File.dirname(__FILE__) + '/../lib/double_agent/resources'
require File.dirname(__FILE__) + '/../lib/double_agent/stats'
require File.dirname(__FILE__) + '/../lib/double_agent/logs'

Rspec.configure do |c|
  c.mock_with :rspec
end
