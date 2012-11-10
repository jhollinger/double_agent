require File.dirname(__FILE__) + '/spec_helper'

describe DoubleAgent do
  context 'Resource' do
    before do
      @user_agent = DoubleAgent.parse 'Mozilla/5.0 (X11; Ubuntu Linux i686; rv:2.0) Gecko/20100101 Firefox/4.0'
    end

    it 'returns Firefox 4 for browser' do
      @user_agent.browser.should == 'Firefox 4'
    end

    it 'returns Firefox for browser_name' do
      @user_agent.browser_name.should == 'Firefox'
    end

    it 'returns 4 for browser_version' do
      @user_agent.browser_version.should == '4'
    end

    it 'returns :firefox for browser_sym' do
      @user_agent.browser_sym.should == :firefox
    end

    it 'returns Firefox for browser_family' do
      @user_agent.browser_family.should == 'Firefox'
    end

    it 'returns :firefox for browser_family_sym' do
      @user_agent.browser_family_sym.should == :firefox
    end

    it 'returns Ubuntua for OS' do
      @user_agent.os.should == 'Ubuntu'
    end

    it 'returns :ubuntu for os_sym' do
      @user_agent.os_sym.should == :ubuntu
    end

    it 'returns GNU/Linux OS family' do
      @user_agent.os_family.should == 'GNU/Linux'
    end

    it 'returns :linux for os_family_sym' do
      @user_agent.os_family_sym.should == :linux
    end
  end
end
