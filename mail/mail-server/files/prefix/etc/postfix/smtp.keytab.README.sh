#!/bin/bash -x

# GSSAPI Kerberos authentication for the smtp service on macOS

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

# 3. PAM plain text authentication for Kerberos smtp service

sudo mkdir -p @PREFIX@/etc/postfix/etc/pam.d
sudo cat <<PAMDSMTP > @PREFIX@/etc/postfix/etc/pam.d/smtp
# smtp: auth account password session with gssapi and plain fallback
auth       sufficient     pam_krb5.so try_first_pass
account    sufficient     pam_krb5.so
auth       required       pam_opendirectory.so
account    required       pam_nologin.so
account    required       pam_opendirectory.so
password   required       pam_opendirectory.so
PAMDSMTP
sudo install -m 0644 -b -B .orig @PREFIX@/etc/dovecot/etc/pam.d/smtp /etc/pam.d

# 4. Create the smtp.keytab file with _postfix permission

sudo /usr/sbin/kadmin -l
# kadmin> ext_keytab -k @PREFIX@/etc/postfix/smtp.keytab smtp/@host@.@domain@.@tld@
# kadmin> exit
sudo chgrp _postfix @PREFIX@/etc/postfix/smtp.keytab
sudo chmod g+r @PREFIX@/etc/postfix/smtp.keytab
sudo -u _postfix @PREFIX@/bin/klist -e -k -t @PREFIX@/etc/postfix/smtp.keytab
## Keytab name: FILE:@PREFIX@/etc/postfix/smtp.keytab
## KVNO Timestamp           Principal
## ---- ------------------- ------------------------------------------------------
##    1 04/25/2019 06:35:54 smtp/@host@.@domain@.@tld@@@HOST@.@DOMAIN@.@TLD@ (aes256-cts-hmac-sha1-96) 
##    1 04/25/2019 06:35:54 smtp/@host@.@domain@.@tld@@@HOST@.@DOMAIN@.@TLD@ (aes128-cts-hmac-sha1-96) 
##    1 04/25/2019 06:35:54 smtp/@host@.@domain@.@tld@@@HOST@.@DOMAIN@.@TLD@ (des3-cbc-sha1) 

# 5. Testing

# Kerberos-only authentication, with debugging;
# assume that ./master.cf doesn't run postfix in chroot jail,
# otherwise edit @PREFIX@/etc/dovecot/etc/pam.d/smtp /etc/pam.d

sudo cat <<PAMDSMTP > /etc/pam.d/smtp
# smtp: auth account password session with gssapi and plain fallback
auth       required       pam_krb5.so try_first_pass debug
account    required       pam_krb5.so
PAMDSMTP

# 5.1 Test with saslauthd observed to work

sudo touch @PREFIX@/etc/sasldb2
sudo chgrp mail @PREFIX@/etc/sasldb2
mail sudo chmod 0640 @PREFIX@/etc/sasldb2

sudo saslauthd -a pam
testsaslauthd -u username -p password -s smtp

sudo log show --last 10s | less
# search for krb5

sudo killall saslauthd

# 5.1 Test with smtpd is *not* (yet) observed to work

# (After postfix configured and loaded)

### /opt/.local/etc/postfix/main.cf (part)
## shlib_directory = @PREFIX@/libexec/postfix
## 
## # Logging
## maillog_file = @PREFIX@/var/log/mail/postfix.log
## maillog_file_compressor = bzip2
## maillog_file_prefixes = @PREFIX@/var/log/mail
## 
## # SMTPD SASL
## smtpd_sasl_auth_enable = yes
## smtpd_tls_security_level = none
## import_environment="KRB5_KTNAME=@PREFIX@/etc/postfix/smtp.keytab"
## smtpd_sasl_local_domain = @host@.@domain@.@tld@
## broken_sasl_auth_clients = yes
## 
## # Dovecot SASL
## smtpd_sasl_path = private/auth
## smtpd_sasl_type = dovecot
## 
## ## SASLAUTHD SASL
## ## smtpd_sasl_path = saslauthd
## ## smtpd_sasl_type = cyrus
## 
## # only allow authentication over TLS
## # (Not set in /Library/Server_v57/Mail/Config/postfix/main.cf)
## # smtpd_tls_auth_only = yes
## smtpd_tls_auth_only = no
## smtpd_recipient_restrictions = permit_mynetworks,
##   permit_sasl_authenticated, reject_unauth_destination

# Check:
sudo bash -c 'port unload postfix ; port unload dovecot2 ; ( cd @PREFIX@/var/log/mail ; > postfix.log ; > mail-err.log ; > mail-debug.log ; > mail-info.log ); port load postfix ; port load dovecot2'
sudo mkdir -p @PREFIX@/var/spool/postfix/etc
touch @PREFIX@/var/spool/postfix/etc/sasldb2
sudo chgrp _postfix @PREFIX@/var/spool/postfix/etc/sasldb2
sudo chmod 0640 @PREFIX@/var/spool/postfix/etc/sasldb2
gtelnet @host@.@domain@.@tld@ 25
# EHLO @host@.@domain@.@tld@
# Use the actual base64 value here:
# AUTH PLAIN `printf "username\000username\000password" | base64`

# Test base64-encoded credentials:
printf "username\000username\000password" | base64 | openssl based64 -d | od -c

sudo less @PREFIX@/var/log/mail/postfix.log

# restore /etc/pam.d/smtp to original above
sudo cp @PREFIX@/etc/dovecot/etc/pam.d/smtp /etc/pam.d

# 6. Debugging

# env KRB5_TRACE=/dev/stdout sudo -E kadmin -p kadmin/admin@@HOST@.@DOMAIN@.@TLD@
# sudo kdestroy -p diradmin@@HOST@.@DOMAIN@.@TLD@
# sudo serveradmin stop dirserv ; sudo serveradmin start dirserv
# dscacheutil -flushcache ; sudo killall -HUP mDNSResponder ; sudo port unload bind9 ; sudo port load bind9
# sudo /usr/sbin/ktutil list
# sudo @PREFIX@/bin/klist -e -k -t /etc/krb5.keytab 
