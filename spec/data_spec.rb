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

  # Safari
  it 'should be Safari 5 on OS X' do
    ua = "Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10_5_8; zh-cn) AppleWebKit/533.20.25 (KHTML, like Gecko) Version/5.0.4 Safari/533.20.27"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Safari 5 on OS X'
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

  # Epiphany
  it 'should be Epiphany on GNU/Linux' do
    ua = "Mozilla/5.0 (X11; U; Linux x86_64; fr-FR) AppleWebKit/534.7 (KHTML, like Gecko) Epiphany/2.30.6 Safari/534.7"
    "#{DA.browser ua} on #{DA.os ua}".should == 'Epiphany on GNU/Linux'
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
