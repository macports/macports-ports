
/* Darwin's poll() implementation is a limited shim atop select() */
#define	    POLLRDNORM      POLLIN
#define     POLLWRNORM      POLLOUT
#define     POLLWRBAND      POLLOUT

#define     INFTIM          (-1)
