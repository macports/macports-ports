# $Id $
# Note: This is a MacPorts-specific extension to the standard content
# of a ruby release intended to enable switching to vendor-specific
# install location.
#
# Default site_ruby install library setting for normal module
# installation. You can force site installation with the following:
#
#    ruby -rsite-specific extconf.rb
# or
#    ruby -rsite-specific install.rb
#
# This is not required for normal user module installation as they will
# default to site_ruby, it is only provided for consistency. Developers
# creating packages/ports should use the vendor-specific option.
#
VENDOR_SPECIFIC=false

