# $Id: destroot-install.rb,v 1.1 2004/04/28 06:21:25 rshaw Exp $
require 'rbconfig'
include Config
DESTDIR=ENV['DESTDIR'] || ''
CONFIG['bindir']=DESTDIR+CONFIG['bindir']
CONFIG['libdir']=DESTDIR+CONFIG['libdir']
