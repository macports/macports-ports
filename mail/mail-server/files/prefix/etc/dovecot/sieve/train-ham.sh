#!/bin/sh
exec @PREFIX@/bin/rspamc -h @PREFIX@/var/run/rspamd/rspamd.sock -P '@RSPAMD_CONTROL_PASSWORD@' learn_ham
