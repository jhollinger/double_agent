require File.dirname(__FILE__) + '/spec_helper'

describe DoubleAgent do
  before do
    @ua_string = 'Mozilla/5.0 (X11; Ubuntu Linux i686; rv:2.0) Gecko/20100101 Firefox/4.0'
  end

  context 'browser_sym' do
    it 'returns :firefox_4' do
      DoubleAgent.browser_sym(@ua_string).should == :firefox_4
    end
    it 'returns :unknown' do
      DoubleAgent.browser_sym('froofroo').should == :unknown
    end
  end

  context 'browser_family_sym' do
    it 'returns :firefox' do
      DoubleAgent.browser_family_sym(@ua_string).should == :firefox
    end
  end

  context 'browser' do
    it 'returns Firefox 4' do
      DoubleAgent.browser(@ua_string).should == 'Firefox 4'
    end
    it 'returns Unknown' do
      DoubleAgent.browser('froofroo').should == 'Unknown'
    end
  end

  context 'browser_family' do
    it 'returns Firefox' do
      DoubleAgent.browser_family(@ua_string).should == 'Firefox'
    end
  end

  context 'os_sym' do
    it 'returns :ubuntu' do
      DoubleAgent.os_sym(@ua_string).should == :ubuntu
    end
    it 'returns :unknown' do
      DoubleAgent.browser_sym('froofroo').should == :unknown
    end
  end

  context 'os_family_sym' do
    it 'returns :linux' do
      DoubleAgent.os_family_sym(@ua_string).should == :linux
    end
  end

  context 'os' do
    it 'returns Ubuntu' do
      DoubleAgent.os(@ua_string).should == 'Ubuntu'
    end
    it 'returns Unknown' do
      DoubleAgent.os('froofroo').should == 'Unknown'
    end
  end

  context 'os_family' do
    it 'returns GNU/Linux' do
      DoubleAgent.os_family(@ua_string).should == 'GNU/Linux'
    end
  end
end
