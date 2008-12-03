[ -n "${USERWM}" -a -x "${USERWM}" ] && exec "${USERWM}"
[ -x /usr/bin/quartz-wm ] && exec /usr/bin/quartz-wm
[ -x /usr/X11/bin/quartz-wm ] && exec /usr/X11/bin/quartz-wm
[ -x /usr/X11R6/bin/quartz-wm ] && exec /usr/X11R6/bin/quartz-wm
