# $Id: vendor-specific.rb,v 1.1 2004/04/02 04:47:43 rshaw Exp $
# Custom vendor_ruby install library setting for DarwinPorts module
# installation. You can force vendor installation with the following:
#
#    ruby -rvendor-specific extconf.rb
# or
#    ruby -rvendor-specific install.rb
#
# This causes vendor-specific installation mode. The default without
# this is to do a site-specific installation, which is recommended for
# general user installation of modules.
#
VENDOR_SPECIFIC=true

