In case you missed it during installation, three lines need to be added to
your .xinitrc file (and to others who wish to use kxterm):

xrdb -merge @@PREFIX@@/share/@@NAME@@/CXterm.ad
xset fp+ @@PREFIX@@/share/@@NAME@@/fonts
xset fp rehash

Be sure to have a look at @@PREFIX@@/share/doc/@@NAME@@/README if the basic
configuration as set by the MacPorts install does not do enough for you
(cxterm and cxtermb5 are both installed, for GB and Big5 use, respectively).

