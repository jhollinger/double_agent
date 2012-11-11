require 'psych'
require 'double_agent/version'
require 'double_agent/parser'
require 'double_agent/resource'
require 'double_agent/user_agent'
require 'double_agent/double_agent'

DoubleAgent.load_browsers!
DoubleAgent.load_oses!
