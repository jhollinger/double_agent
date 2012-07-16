require File.dirname(__FILE__) + '/spec_helper'

log_glob = File.dirname(__FILE__) + '/data/*.access.log*'
entries = DoubleAgent::Logs::entries(log_glob, :match => /^\d/)

describe DoubleAgent do
  context 'Logs' do
    it 'should have loaded n log entries' do
      entries.size.should == 48
    end

    it 'should have loaded n log entries' do
      DoubleAgent::Logs::entries(log_glob, :match => /^\d/, :ignore => %r{ /dashboard }).size.should == 45
    end

    context 'without zlib' do
      it 'should have loaded n log entries' do
        suppress_warnings { DoubleAgent::Logs::ZLIB = false }
        plain_entries = DoubleAgent::Logs::entries(log_glob, :match => /^\d/)
        suppress_warnings { DoubleAgent::Logs::ZLIB = true }
        plain_entries.size.should == 18
      end
    end

    context 'parsing other data' do
      before :each do
        @line = DoubleAgent::Logs::Entry.new '68.52.99.211 - - [04/May/2011:08:21:04 -0400] "GET / HTTP/1.1" 200 1312 "-" "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.17) Gecko/20110420 Firefox/3.6.17"'
      end

      it 'should parse the IP' do
        @line.ip.should == '68.52.99.211'
      end

      it 'should parse datestamps' do
        @line.on.should == Date.new(2011, 5, 4)
      end

      it 'should parse timestamps' do
        @line.at.should == DateTime.new(2011, 5, 4, 8, 21, 4, '-0400')
      end
    end
  end

  context 'Stats' do
    it 'should calculate stats' do
      stats = DoubleAgent::Stats.percentages_for entries, :browser_family, :os_family
      answer = [["Internet Explorer", "Windows", 41.67, 20],
                ["Android", "GNU/Linux", 39.58, 19],
                ["Firefox", "GNU/Linux", 10.42, 5],
                ["Firefox", "OS X", 4.17, 2],
                ["Safari", "OS X", 2.08, 1],
                ["Chromium", "GNU/Linux", 2.08, 1]]
      stats.should == answer
    end

    it 'should ignore stats below the threshold' do
      stats = DoubleAgent::Stats.percentages_for entries, :browser_family, :os_family, :threshold => 3.0
      answer = [["Internet Explorer", "Windows", 41.67, 20],
                ["Android", "GNU/Linux", 39.58, 19],
                ["Firefox", "GNU/Linux", 10.42, 5],
                ["Firefox", "OS X", 4.17, 2]]
      stats.should == answer
    end
  end
end
