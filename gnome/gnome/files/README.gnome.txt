You have installed the DarwinPorts GNOME meta/mega port!

Further information is available from the web at:
http://svn.macosforge.org/projects/macports/wiki/GNOME

You can subscribe to the MacPorts Users mailing list at:
http://lists.macosforge.org/mailman/listinfo/macports-users

The mailing list the best way the resolve darwinports GNOME issues.

Question 1) 
--------------------------------------------------------------------------
How do I get GNOME running ?

Answer 1) 
--------------------------------------------------------------------------
Place the following in your .xinitrc 
(copying the one from /etc/X11/xinit/ is advisable), \
the path should be changed if you dont use the default DarwinPorts location:

# start the window manager
PATH=$PATH:/opt/local/bin
exec gnome-session

See also:
http://svn.macosforge.org/projects/macports/wiki/GNOME#Running_GNOME
