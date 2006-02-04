You have installed the DarwinPorts GNOME meta/mega port!

Further information is available from the web at:
http://wiki.opendarwin.org/index.php/DarwinPorts:GNOME

You can subscribe to the gnome-darwinports mailing list at:
http://opendarwin.org/mailman/listinfo/gnome-darwinports

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
http://wiki.opendarwin.org/index.php/DarwinPorts:GNOME#Running_GNOME
