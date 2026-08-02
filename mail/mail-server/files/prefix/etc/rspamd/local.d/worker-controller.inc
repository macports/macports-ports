# generate a password hash using the `rspamadm pw` command and put it here
# this one is the hash for 'foobar'
# password = "$2$p4oabgj4wersc73owwt8dyi4iokuhrw7$15p5am33jpfxxnfxeazrf8tjfr4ck5x39ku731yj973wdux9r5ub";
# enable_password = "$2$p4oabgj4wersc73owwt8dyi4iokuhrw7$15p5am33jpfxxnfxeazrf8tjfr4ck5x39ku731yj973wdux9r5ub";
password = "@RSPAMD_CONTROL_PASSWORD_HASH@";
enable_password = "@RSPAMD_CONTROL_PASSWORD_HASH@";

# dovecot will use this socket to communicate with rspamd
# it must be rw by any mail user accounts
bind_socket = "$RUNDIR/rspamd.sock mode=0666 owner=_rspamd";

# you can comment this out if you don't need the web interface
bind_socket = "127.0.0.1:11334";
