require File.dirname(__FILE__) + '/spec_helper'

describe DoubleAgent do
  context 'Resource' do
    before do
      @user_agent = DoubleAgent.parse 'Mozilla/5.0 (X11; Ubuntu Linux i686; rv:2.0) Gecko/20100101 Firefox/4.0'
    end

    #browser
    it 'returns Firefox 4 for browser' do
      @user_agent.browser.should == 'Firefox 4'
    end

    #browser_sym
    it 'returns :firefox for browser_sym' do
      @user_agent.browser_sym.should == :firefox
    end

    #browser_family
    it 'returns Firefox for browser family' do
      @user_agent.browser_family.should == 'Firefox'
    end

    #browser_family_sym
    it 'returns :firefox for browser_family_sym' do
      @user_agent.browser_family_sym.should == :firefox
    end

    #os
    it 'returns Ubuntua for OS' do
      @user_agent.os.should == 'Ubuntu'
    end

    #os_sym
    it 'returns :ubuntu for os_sym' do
      @user_agent.os_sym.should == :ubuntu
    end

    #os_family
    it 'returns GNU/Linux OS family' do
      @user_agent.os_family.should == 'GNU/Linux'
    end

    #os_family_sym
    it 'returns :linux for os_family_sym' do
      @user_agent.os_family_sym.should == :linux
    end
  end
end
