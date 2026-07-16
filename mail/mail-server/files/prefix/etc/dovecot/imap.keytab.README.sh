#!/bin/bash -x

# GSSAPI Kerberos authentication for the imap service on macOS

# 1. krb5 configuration

# Create missing edu.mit.Kerberos file, copy it to /etc/krb5.conf
# See http://nusoft.fnal.gov/ifmon/maint/auth/macadmin.html

sudo cat <<KERBEROSCONF > edu.mit.Kerberos
[domain_realm]
        .@domain@.@tld@ = @HOST@.@DOMAIN@.@TLD@
        @domain@.@tld@ = @HOST@.@DOMAIN@.@TLD@
        @host@.@domain@.@tld@ = @HOST@.@DOMAIN@.@TLD@

[libdefaults]
        default_realm = @HOST@.@DOMAIN@.@TLD@
        kdc_timeout = 5
        allow_weak_crypto = false
        dns_lookup_kdc = true
        ticket_lifetime = 90000
        renew_lifetime = 300000
        noaddresses = true

[realms]
        @HOST@.@DOMAIN@.@TLD@ = {
                default_domain = @host@.@domain@.@tld@
                admin_server = @host@.@domain@.@tld@
                kdc = @host@.@domain@.@tld@
        }

[logging]
        kdc = CONSOLE
        kdc = SYSLOG:INFO:DAEMON
        admin_server = FILE:/private/var/log/krb5kdc/kadmin.log
KERBEROSCONF
sudo install -m 0644 -b -B .orig edu.mit.Kerberos /etc/krb5.conf 
rm edu.mit.Kerberos

# 2. DNS configuration

# Add these DNS URI, TXT, and SRV records to the primary zone corresponding to REALM
sudo vi @PREFIX@/var/named/db.@domain@.@tld@
if false; do
	sudo cat <<KERBEROSDNS >> @PREFIX@/var/named/db.@domain@.@tld@
	; Kerberos configuration with URI, TXT, and SRV records
	_kerberos.@HOST@.@DOMAIN@.@TLD@.    IN      URI     10 1 "udp://@host@.@domain@.@tld@"
	_kerberos.@HOST@.@DOMAIN@.@TLD@.    IN      URI     20 1 "tcp://@host@.@domain@.@tld@"
	_kerberos-master.@HOST@.@DOMAIN@.@TLD@. IN  URI     10 1 "udp://@host@.@domain@.@tld@"
	_kerberos-master.@HOST@.@DOMAIN@.@TLD@. IN  URI     20 1 "tcp://@host@.@domain@.@tld@"
	_kerberos.@host@.@domain@.@tld@.    IN      TXT     "@HOST@.@DOMAIN@.@TLD@"
	_kerberos-master.@host@.@domain@.@tld@. IN  TXT     "@HOST@.@DOMAIN@.@TLD@"
	_kerberos._udp.@HOST@.@DOMAIN@.@TLD@. IN    SRV     10 1 88 @host@.@domain@.@tld@.
	_kerberos._tcp.@HOST@.@DOMAIN@.@TLD@. IN    SRV     10 1 88 @host@.@domain@.@tld@.
	_kerberos._tls._tcp.@HOST@.@DOMAIN@.@TLD@. IN SRV   10 1 88 @host@.@domain@.@tld@.
	_kerberos-master._udp.@HOST@.@DOMAIN@.@TLD@. IN SRV 10 1 749 @host@.@domain@.@tld@.
	_kerberos-master._tcp.@HOST@.@DOMAIN@.@TLD@. IN SRV 10 1 749 @host@.@domain@.@tld@.
	_kerberos-master._tls._tcp.@HOST@.@DOMAIN@.@TLD@. IN SRV    10 1 749 @host@.@domain@.@tld@.
KERBEROSDNS
	done
# flush DNS cache and restart named
dscacheutil -flushcache ; sudo killall -HUP mDNSResponder ; sudo port unload bind9 ; sudo port load bind9

# 3. PAM plain text authentication for Kerberos imap service

sudo mkdir -p @PREFIX@/etc/dovecot/etc/pam.d
sudo cat <<PAMDSMTP > @PREFIX@/etc/dovecot/etc/pam.d/imap
# imap: auth account password session with gssapi and plain fallback
auth       sufficient     pam_krb5.so try_first_pass
account    sufficient     pam_krb5.so
auth       required       pam_opendirectory.so
account    required       pam_nologin.so
account    required       pam_opendirectory.so
password   required       pam_opendirectory.so
PAMDSMTP
sudo install -m 0644 -b -B .orig @PREFIX@/etc/dovecot/etc/pam.d/imap /etc/pam.d

# 4. Create the imap.keytab file with _dovecot permission

sudo /usr/sbin/kadmin -l
# kadmin> ext_keytab -k @PREFIX@/etc/dovecot/imap.keytab imap/@host@.@domain@.@tld@
# kadmin> exit
sudo chgrp _dovenull @PREFIX@/etc/dovecot/imap.keytab
sudo chmod g+r @PREFIX@/etc/dovecot/imap.keytab
sudo -u _dovenull @PREFIX@/bin/klist -e -k -t @PREFIX@/etc/dovecot/imap.keytab
## Keytab name: FILE:@PREFIX@/etc/dovecot/imap.keytab
## KVNO Timestamp           Principal
## ---- ------------------- ------------------------------------------------------
##    1 04/25/2019 07:11:41 imap/@host@.@domain@.@tld@@@HOST@.@DOMAIN@.@TLD@ (aes256-cts-hmac-sha1-96) 
##    1 04/25/2019 07:11:41 imap/@host@.@domain@.@tld@@@HOST@.@DOMAIN@.@TLD@ (aes128-cts-hmac-sha1-96) 
##    1 04/25/2019 07:11:41 imap/@host@.@domain@.@tld@@@HOST@.@DOMAIN@.@TLD@ (des3-cbc-sha1)

# 5. Testing

# https://wiki.dovecot.org/TestInstallation

openssl s_client -connect @host@.@domain@.@tld@:993

# a login "username" "password"
# b select inbox
# c list "" *
# d lsub "" *
# e logout

# 6. Debugging

# env KRB5_TRACE=/dev/stdout sudo -E kadmin -p kadmin/admin@@HOST@.@DOMAIN@.@TLD@
# sudo kdestroy -p diradmin@@HOST@.@DOMAIN@.@TLD@
# sudo serveradmin stop dirserv ; sudo serveradmin start dirserv
# dscacheutil -flushcache ; sudo killall -HUP mDNSResponder ; sudo port unload bind9 ; sudo port load bind9
# sudo /usr/sbin/ktutil list
# sudo @PREFIX@/bin/klist -e -k -t /etc/krb5.keytab 
