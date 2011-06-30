require File.dirname(__FILE__) + '/spec_helper'

describe DoubleAgent do
  context 'Core' do
    before do
      @ua_string = 'Mozilla/5.0 (X11; Ubuntu Linux i686; rv:2.0) Gecko/20100101 Firefox/4.0'
    end

    #browser
    it 'returns Firefox 4 for browser' do
      DoubleAgent.browser(@ua_string).should == 'Firefox 4'
    end
    it 'returns Unknown for browser' do
      DoubleAgent.browser('froofroo').should == 'Unknown'
    end

    #browser_sym
    it 'returns :firefox for browser_sym' do
      DoubleAgent.browser_sym(@ua_string).should == :firefox
    end
    it 'returns :unknown for browser_sym' do
      DoubleAgent.browser_sym('froofroo').should == :unknown
    end
    it 'returns :unknown for an empty browser_sym' do
      DoubleAgent.browser_sym('').should == :unknown
    end
    it 'returns :unknown for a nil browser_sym' do
      DoubleAgent.browser_sym(nil).should == :unknown
    end

    #browser_family
    it 'returns Firefox for browser family' do
      DoubleAgent.browser_family(@ua_string).should == 'Firefox'
    end

    #browser_family_sym
    it 'returns :firefox for browser_family_sym' do
      DoubleAgent.browser_family_sym(@ua_string).should == :firefox
    end
    it 'returns :unknown for an empty browser_family_sym' do
      DoubleAgent.browser_family_sym('').should == :unknown
    end
    it 'returns :unknown for a nil browser_family_sym' do
      DoubleAgent.browser_family_sym(nil).should == :unknown
    end

    #browser_icon
    it 'returns :firefox for browser_sym' do
      DoubleAgent.browser_icon(@ua_string).should == :firefox
    end
    it 'returns :unkown for an empty browser_sym' do
      DoubleAgent.browser_icon('').should == :unknown
    end
    it 'returns :unkown for a nil browser_sym' do
      DoubleAgent.browser_icon(nil).should == :unknown
    end

    #browser_family_icon
    it 'returns :firefox for browser_family_sym' do
      DoubleAgent.browser_family_icon(@ua_string).should == :firefox
    end
    it 'returns :unkown for an empty browser_family_sym' do
      DoubleAgent.browser_family_icon('').should == :unknown
    end
    it 'returns :unkown for a nil browser_family_sym' do
      DoubleAgent.browser_family_icon(nil).should == :unknown
    end

    #os
    it 'returns Ubuntua for OS' do
      DoubleAgent.os(@ua_string).should == 'Ubuntu'
    end
    it 'returns Unknowna for OS' do
      DoubleAgent.os('froofroo').should == 'Unknown'
    end
    it 'returns Unknowna for OS' do
      DoubleAgent.os('').should == 'Unknown'
    end

    #os_sym
    it 'returns :ubuntu for os_sym' do
      DoubleAgent.os_sym(@ua_string).should == :ubuntu
    end
    it 'returns :unknown for os_sym' do
      DoubleAgent.os_sym('froofroo').should == :unknown
    end
    it 'returns :unknown for an empty os_sym' do
      DoubleAgent.os_sym('').should == :unknown
    end
    it 'returns :unknown for a nil os_sym' do
      DoubleAgent.os_sym(nil).should == :unknown
    end

    #os_family
    it 'returns GNU/Linux OS family' do
      DoubleAgent.os_family(@ua_string).should == 'GNU/Linux'
    end

    #os_family_sym
    it 'returns :linux for os_family_sym' do
      DoubleAgent.os_family_sym(@ua_string).should == :linux
    end

    #os_icon
    it 'returns :ubuntu for os_sym' do
      DoubleAgent.os_icon(@ua_string).should == :ubuntu
    end

    #os_family_icon
    it 'returns :linux for os_family_sym' do
      DoubleAgent.os_family_icon(@ua_string).should == :linux
    end
  end
end
