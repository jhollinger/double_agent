require File.dirname(__FILE__) + '/spec_helper'

log_glob = File.dirname(__FILE__) + '/data/*.access.log*'
entries = DoubleAgent::log_entries(log_glob, :match => /^\d/)

describe DoubleAgent do
  context 'Logs' do
    it 'should have loaded n log entries' do
      entries.size.should == 47
    end

    it 'should have loaded n log entries' do
      DoubleAgent::log_entries(log_glob, :match => /^\d/, :ignore => %r{ /dashboard }).size.should == 44
    end
  end

  context 'Stats' do
    it 'should calculate stats' do
      stats = DoubleAgent.percentages_for entries, :browser_family, :os_family
      answer = [["Internet Explorer", "Windows", 42.55],
                ["Chromium", "GNU/Linux", 40.43],
                ["Firefox", "GNU/Linux", 10.64],
                ["Firefox", "OS X", 4.26],
                ["Safari", "OS X", 2.13]]
      stats.should == answer
    end

    it 'should ignore stats below the threshold' do
      stats = DoubleAgent.percentages_for entries, :browser_family, :os_family, :threshold => 3.0
      answer = [["Internet Explorer", "Windows", 42.55],
                ["Chromium", "GNU/Linux", 40.43],
                ["Firefox", "GNU/Linux", 10.64],
                ["Firefox", "OS X", 4.26]]
      stats.should == answer
    end
  end
end
