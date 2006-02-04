You have installed the DarwinPorts GNOME desktop suite meta port!

Further information is available from the web at:
http://wiki.opendarwin.org/index.php/DarwinPorts:GNOME

You can subscribe to the gnome-darwinports mailing list at:
http://opendarwin.org/mailman/listinfo/gnome-darwinports

The mailing list the best way the resolve darwinports GNOME issues.

Questions
==========================================================================
1) What is the GNOME desktop suite?

2) How do I get GNOME running?

Answers 
==========================================================================
1) What is the GNOME desktop suite?

The GNOME desktop suite is the complete set of software packages required to
have a complete GNOME/GTK-based desktop environment.

--------------------------------------------------------------------------
2) How do I get GNOME running?
Place the following in your .xinitrc 
(copying the one from /etc/X11/xinit/ is advisable), \
the path should be changed if you dont use the default DarwinPorts location:

# start the window manager
PATH=$PATH:/opt/local/bin
exec gnome-session

See also:
http://wiki.opendarwin.org/index.php/DarwinPorts:GNOME#Running_GNOME
