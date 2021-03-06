# encoding: utf-8
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

  # Chrome
  it 'should be Chrome 12 on Windows XP' do
    ua = "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/534.25 (KHTML, like Gecko) Chrome/12.0.706.0 Safari/534.25"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Chrome 12 on Windows XP'
  end

  # Chromium
  it 'should be Chrome 12 on Ubuntu' do
    ua = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/534.24 (KHTML, like Gecko) Ubuntu/10.10 Chromium/12.0.703.0 Chrome/12.0.703.0 Safari/534.24"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Chrome 12 on Ubuntu'
  end

  # Android
  it 'should be Android 2.3 on Android' do
    ua = "Mozilla/5.0 (Linux; U; Android 2.3.3; zh-tw; HTC_Pyramid Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Android 2.3 on Android'
  end

  it 'should be mobile' do
    ua = "Mozilla/5.0 (Linux; U; Android 2.3.3; zh-tw; HTC_Pyramid Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
    DA.parse(ua).mobile?.should == true
    DA.mobile?(ua).should == true
  end

  # Safari
  it 'should be Safari 5 on OS X' do
    ua = "Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10_5_8; zh-cn) AppleWebKit/533.20.25 (KHTML, like Gecko) Version/5.0.4 Safari/533.20.27"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Safari 5 on OS X'
  end

  it 'should be Safari on iPhone (iOS)' do
    ua = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_1_2 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7D11 Safari/528.16"
    "#{DA.browser ua} on #{DA.os ua} (#{DA.os_family ua})".should == 'Safari 4 on iPhone (iOS)'
  end

  it 'should be Safari on iPad (iOS)' do
    ua = "Mozilla/5.0 (iPad; U; CPU OS 4_2_1 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8C148 Safari/6533.18.5"
    "#{DA.browser ua} on #{DA.os ua} (#{DA.os_family ua})".should == 'Safari 5 on iPad (iOS)'
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

  # Firefox
  it 'should be Firefox 4 on GNU/Linux' do
    ua = "Mozilla/5.0 (X11; U; Linux x86_64; pl-PL; rv:2.0) Gecko/20110307 Firefox/4.0"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Firefox 4 on GNU/Linux'
  end

  it 'should be Firefox 7 on Android' do
    ua = "Mozilla/5.0 (Android; Linux armv7l; rv:7.0.1) Gecko/20110928 Firefox/7.0.1 Fennec/7.0.1"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Firefox 7 on Android'
  end

  # Kindle
  it 'should be Kindle on Kindle' do
    ua = "Mozilla/5.0 (Linux; U; en-US) AppleWebKit/528.5+ (KHTML, like Gecko, Safari/528.5+) Version/4.0 Kindle/3.0 (screen 600×800; rotate)"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Kindle on Kindle'
  end

  it 'should be Kindle Fire on Kindle Fire' do
    ua = "Mozilla/5.0 (Linux; U; Android 2.3.4; en-us; Kindle Fire Build/GINGERBREAD) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Kindle Fire on Kindle Fire'
  end

  it 'should be Kindle Fire (Silk) on Kindle Fire' do
    ua = "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_3; en-us; Silk/1.1.0-80) AppleWebKit/533.16 (KHTML, like Gecko) Version/5.0 Safari/533.16 Silk-Accelerated=true"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Kindle Fire (Silk) on Kindle Fire'
  end

  # Epiphany
  it 'should be Epiphany 3 on GNU/Linux' do
    ua = "Mozilla/5.0 (X11; Linux i686) AppleWebKit/535.22+ (KHTML, like Gecko) Chromium/17.0.963.56 Chrome/17.0.963.56 Safari/535.22+ Ubuntu/12.04 (3.4.1-0ubuntu1) Epiphany/3.4.1"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Epiphany 3 on Ubuntu'
  end

  # Konqueror
  it 'should be Konqueror on FreeBSD' do
    ua = "Mozilla/5.0 (compatible; Konqueror/4.5; FreeBSD) KHTML/4.5.4 (like Gecko)"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Konqueror on FreeBSD'
  end

  it 'should be Konqueror on Fedora' do
    ua = "Mozilla/5.0 (compatible; Konqueror/4.4; Linux) KHTML/4.4.1 (like Gecko) Fedora/4.4.1-1.fc12"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Konqueror on Fedora'
  end

  it 'should be Konqueror on Slackware' do
    ua = "Mozilla/5.0 (compatible; Konqueror/4.2; Linux) KHTML/4.2.4 (like Gecko) Slackware/13.0"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Konqueror on Slackware'
  end

  # BlackBerry
  it 'should be BlackBerry on BlackBerry' do
    ua = "Mozilla/5.0 (BlackBerry; U; BlackBerry 9800; zh-TW) AppleWebKit/534.8+ (KHTML, like Gecko) Version/6.0.0.448 Mobile Safari/534.8+"
    "#{DA.browser ua} on #{DA.os ua}".should == 'BlackBerry on BlackBerry'
  end
end
