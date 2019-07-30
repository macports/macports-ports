# this worker will be used as postfix milter
milter = yes;

# Proxy worker is listening on *:11332 by default
#bind_socket = localhost:11332;

# Use this socket if postfix is *not* run in *chroot*
# sudo chgrp mail @PREFIX@/var/run/rspamd
# bind_socket = "$RUNDIR/milter.sock mode=0660 owner=_rspamd group=mail";

# Use this socket if postfix is run in chroot
# sudo mkdir -p @PREFIX@/var/spool/postfix@PREFIX@/var/run/rspamd
# sudo chgrp mail @PREFIX@/var/spool/postfix@PREFIX@/var/run/rspamd
# sudo chmod 0750 @PREFIX@/var/spool/postfix@PREFIX@/var/run/rspamd
bind_socket = "@PREFIX@/var/spool/postfix$RUNDIR/milter.sock mode=0660 owner=_rspamd group=mail";

# the following specifies self-scan mode, for when rspamd is on the same
# machine as postfix
timeout = 120s;
upstream "local" {
  default = yes;
  self_scan = yes;
}
