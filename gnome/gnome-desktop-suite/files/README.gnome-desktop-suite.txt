You have installed the DarwinPorts GNOME desktop suite meta port!

Further information is available from the web at:
http://svn.macosforge.org/projects/macports/wiki/GNOME

You can subscribe to the gnome-darwinports mailing list at:
http://lists.macosforge.org/mailman/listinfo/macports-users

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
http://svn.macosforge.org/projects/macports/wiki/GNOME#Running_GNOME
