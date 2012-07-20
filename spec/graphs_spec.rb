require File.dirname(__FILE__) + '/spec_helper'
require 'double_agent/graphs'
require 'digest/md5'

if defined? Gruff
  log_glob = File.dirname(__FILE__) + '/data/*.access.log*'
  entries = DoubleAgent::Logs::entries(log_glob, :match => /^\d/)

  describe DoubleAgent do
    context 'Graphs' do
      before :each do
        @file_path = '/tmp/double_agent_graph_test.png'
        @md5 = ->(path) { Digest::MD5.hexdigest(File.read(path)) }
      end

      after :each do
        File.unlink(@file_path) if File.exists? @file_path
      end

      it 'should write a simple pie chart' do
        DoubleAgent::Stats.percentages(entries, :browser_family).pie_chart(@file_path, 'Browser Share')
        @md5[@file_path].should == '43c02b8cd360b9b4a2675e2d11eed5ba'
      end

      it 'should write a complex pie chart' do
        DoubleAgent::Stats.percentages(entries, :browser_family).pie_chart(@file_path) do |pie|
          pie.title = 'Browser Share'
        end
        @md5[@file_path].should == '43c02b8cd360b9b4a2675e2d11eed5ba'
      end

      it 'should write a simple multiline graph' do
        DoubleAgent::Stats.percentages(entries, :browser_family).line_graph(:date, @file_path, 'Browser Share')
        @md5[@file_path].should == '4eddcafdbdd6b2936bfaade1b72990a6'
      end

      it 'should write a formatted line graph' do
        DoubleAgent::Stats.percentages(entries, :browser_family).line_graph(:date, @file_path, 'Browser Share') do |chart, labeler|
          chart.theme = chart.theme_odeo

          labeler.call(2) do |date|
            date.strftime('%m/%d/%Y')
          end
        end
        @md5[@file_path].should == '9e05efd35cb8ff361dfc20ee6a0d62e0'
      end

      it 'should write a monthly line graph' do
        DoubleAgent::Stats.percentages(entries, :browser_family).line_graph(->(e) { e.date.strftime('%m/%Y') }, @file_path, 'Browser Share') do |chart, labeler|
          chart.theme = chart.theme_odeo
        end
        @md5[@file_path].should == '263562b4e4eacbe283958116c7072c0d'
      end
    end
  end
end
