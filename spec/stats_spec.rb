require File.dirname(__FILE__) + '/spec_helper'

log_glob = File.dirname(__FILE__) + '/data/*.access.log*'
entries = DoubleAgent::log_entries(log_glob, /^\d/)

describe DoubleAgent do
  context 'Logs' do
    it 'should have loaded n log entries' do
      entries.size.should == 47
    end
  end

  context 'Stats' do
    stats = DoubleAgent.percentages_for entries, :browser_family, :os_family
    answer = [["Internet Explorer", "Windows", 42.55],
              ["Chromium", "GNU/Linux", 40.43],
              ["Firefox", "GNU/Linux", 10.64],
              ["Firefox", "OS X", 4.26],
              ["Safari", "OS X", 2.13]]
    stats.should == answer
  end
end
