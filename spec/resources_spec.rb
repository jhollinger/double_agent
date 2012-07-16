require File.dirname(__FILE__) + '/spec_helper'

class Login
  include DoubleAgent::Resource
  attr_accessor :user_agent

  def initialize(ua)
    @user_agent = ua
  end
end

describe DoubleAgent do
  context 'Resource' do
    before do
      @login = Login.new 'Mozilla/5.0 (X11; Ubuntu Linux i686; rv:2.0) Gecko/20100101 Firefox/4.0'
    end

    #browser
    it 'returns Firefox 4 for browser' do
      @login.browser.should == 'Firefox 4'
    end

    #browser_sym
    it 'returns :firefox for browser_sym' do
      @login.browser_sym.should == :firefox
    end

    #browser_family
    it 'returns Firefox for browser family' do
      @login.browser_family.should == 'Firefox'
    end

    #browser_family_sym
    it 'returns :firefox for browser_family_sym' do
      @login.browser_family_sym.should == :firefox
    end

    #os
    it 'returns Ubuntua for OS' do
      @login.os.should == 'Ubuntu'
    end

    #os_sym
    it 'returns :ubuntu for os_sym' do
      @login.os_sym.should == :ubuntu
    end

    #os_family
    it 'returns GNU/Linux OS family' do
      @login.os_family.should == 'GNU/Linux'
    end

    #os_family_sym
    it 'returns :linux for os_family_sym' do
      @login.os_family_sym.should == :linux
    end
  end
end
