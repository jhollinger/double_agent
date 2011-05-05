require File.dirname(__FILE__) + '/spec_helper'

DA = DoubleAgent

describe DoubleAgent do
  # Internet Explorer
  it 'should be Internet Explorer 10 on Windows 8' do
    ua = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; Win64; x64; Trident/5.0"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Internet Explorer 10 on Windows 8'
  end

  it 'should be Internet Explorer 9 on Windows 7' do
    ua = "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Internet Explorer 9 on Windows 7'
  end

  it 'should be Internet Explorer 8 on Windows Vista' do
    ua = "Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 6.0; Win64; x64; Trident/5.0"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Internet Explorer 8 on Windows Vista'
  end

  it 'should be Internet Explorer 7 on Windows XP' do
    ua = "Mozilla/5.0 (compatible; MSIE 7.0; Windows NT 5.2; Win64; x64; Trident/5.0"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Internet Explorer 7 on Windows XP'
  end

  it 'should be Internet Explorer 7 on Windows XP' do
    ua = "Mozilla/5.0 (compatible; MSIE 7.0; Windows NT 5.1; Win64; x64; Trident/5.0"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Internet Explorer 7 on Windows XP'
  end

  # Firefox
  it 'should be Firefox 4 on GNU/Linux' do
    ua = "Mozilla/5.0 (X11; U; Linux x86_64; pl-PL; rv:2.0) Gecko/20110307 Firefox/4.0"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Firefox 4 on GNU/Linux'
  end

  # Opera
  it 'should be Opera 11 on GNU/Linux' do
    ua = "Opera/9.80 (X11; Linux x86_64; U; pl) Presto/2.7.62 Version/11.00"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Opera 11 on GNU/Linux'
  end

  it 'should be Opera 11 on Windows 7' do
    ua = "Mozilla/5.0 (Windows NT 6.1; U; nl; rv:1.9.1.6) Gecko/20091201 Firefox/3.5.6 Opera 11.01"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Opera 11 on Windows 7'
  end
end
