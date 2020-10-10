#!@PREFIX@/bin/perl@PERL5_MAJOR_VERSION@ -w -T

# Based on https://github.com/matthewpowell/pushnotify
# LGPLv2.1

use strict;
use lib '@PREFIX@/lib/pushnotify';

use Privileges::Drop;
use IO::Socket::UNIX qw( SOCK_DGRAM SOMAXCONN );
use Sys::Syslog qw( openlog syslog LOG_INFO );
use Net::APNS::SimpleCert;

sub save_devices;

# Dovecot's push notification socket
my $sockpath = '@PREFIX@/var/run/dovecot/push_notify';

# user to drop privileges to
my $user = '@DEFAULT_INTERNAL_USER@';

# A file containing registration information
my $devicepath = '@PREFIX@/var/db/dovecot-apns/devices';

# APNS certificate
my $apns_cert = '@PREFIX@/etc/dovecot-apns/com.apple.mail.cert.pem';

# APNS key (might be the same as $apns_cert)
my $apns_key = '@PREFIX@/etc/dovecot-apns/com.apple.mail.key.pem';

# Read in the list of registered devices.
my %devices;
if (open DEVICES, $devicepath) {
	while (<DEVICES>) {
		chomp;
		my ($username, $devicedata) = split /:/;
		push @{$devices{$username}}, $devicedata;
	}
	close DEVICES;
}

# Open the socket to Dovecot
unlink $sockpath;
umask (0111);
my $socket = IO::Socket::UNIX->new(
	Type  => SOCK_DGRAM,
	Local => $sockpath,
	Listen => SOMAXCONN,
) or die("Can't create server socket: $!\n");

drop_privileges($user);

openlog ('pushnotify', 'ndelay', 'mail');

# We'll defer connecting to APNS until our first notification, but define $apns here
my $apns;

syslog (LOG_INFO, 'Atomnet push notify service running');

while(1)
{
	my $data;
	$socket->recv($data, 2048);

	my ($junk, $username, $aps_acct_id, $aps_dev_token, $aps_sub_topic) = split /\0+/, $data;

	if ($aps_acct_id) {
		$aps_dev_token = lc($aps_dev_token);

		my $devicedata = join ',', $aps_acct_id, $aps_dev_token, $aps_sub_topic, time;

		syslog (LOG_INFO, "Register device $aps_dev_token for $username");
		# Cancel any duplicate registration
		@{$devices{$username}} = grep {!/$aps_dev_token/} @{$devices{$username}};
		# Register new device
		push @{$devices{$username}}, $devicedata;
		save_devices;
	} else {
		if (defined $devices{$username}) {
			# User has at least one device registered

			# Do the push notification
			foreach (@{$devices{$username}}) {
				my ($aps_acct_id, $aps_dev_token, $aps_sub_topic, $time) = split /,/;
				syslog(LOG_INFO, "Send notification to $aps_dev_token for $username");
				eval {
					$apns->prepare (
						$aps_dev_token,
						{
							aps => {
								'account-id' => $aps_acct_id
							},
						});
					$apns->notify;
					1;
				} or do {
					# Failed; connect to APNS and try again
					syslog(LOG_INFO, 'Connect to APNS push gateway');
					eval { $apns->disconnect };

					$apns = Net::APNS::SimpleCert->new({
						development => 0,
						cert => $apns_cert,
						key => $apns_key 
					});
					$apns->prepare (
						$aps_dev_token,
						{
							aps => {
								'account-id' => $aps_acct_id
							},
						});
					$apns->notify;
				}	
			}
		}
	}
}

sub save_devices {
	# Save our registration data
	umask (0077);
	open DEVICES, ">$devicepath";
	foreach my $username (keys %devices) {
		foreach my $devicedata (@{$devices{$username}}) {
			print DEVICES "$username:$devicedata\n";
		}
	}
	close DEVICES;
}
