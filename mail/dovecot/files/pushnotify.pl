#!@PREFIX@/bin/perl@PERL5_MAJOR_VERSION@

use strict;
use warnings;

use Privileges::Drop;
use Getopt::Long;
use IO::Socket::UNIX qw( SOCK_DGRAM SOMAXCONN );
use Sys::Syslog qw( openlog syslog LOG_INFO );
use Net::APNS::Persistent;
use Net::APNS::Feedback;

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

my $help;

sub usage {
<<"EOF";
$0 [arguments]

Arguments:
  --user <unprivileged_user>     (default $user)
  --tokendb <devices_file>       (default $devicepath)
  --certfile <apns_certificate>  (default $apns_cert)
  --keyfile <apns_privkey>       (default $apns_key)
  --help
EOF
}

GetOptions('user=s'     => \$user,
           'tokendb=s'  => \$devicepath,
           'certfile=s' => \$apns_cert,
           'keyfile=s'  => \$apns_key,
           'help'       => \$help)
or die usage;

if ($help) {
  print usage;
  exit 0;
}

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
Type   => SOCK_DGRAM,
Local  => $sockpath,
Listen => SOMAXCONN,
)
or die("Can't create server socket: $!\n");

drop_privileges($user);

openlog ('apns', 'ndelay', 'mail');

# When we last checked the feedback service (right now, never).
my $last_feedback = 0;
# When we last reconnected to APNS
my $last_connect = 0;

# We'll defer connecting to APNS until our first notification, but define $apns here
my $apns;

syslog (LOG_INFO, 'Dovecot APNS service running');

while(1)
{
my $data;
$socket->recv($data, 2048);

my $pretty = join('|', split(/\0+/, $data));
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
				die if (time - $last_connect > 600);
				$apns->queue_notification (
					$aps_dev_token,
					{
						aps => {
							'account-id' => $aps_acct_id
						},
					});
				$apns->send_queue;
					1;
				} or do {
					# Failed; connect to APNS and try again
					syslog(LOG_INFO, 'Connect to APNS push gateway');
					$last_connect = time;
					eval { $apns->disconnect };

					$apns = Net::APNS::Persistent->new({
						sandbox => 0,
						cert => $apns_cert,
						key => $apns_key 
					});
					$apns->queue_notification (
						$aps_dev_token,
						{
							aps => {
								'account-id' => $aps_acct_id
							},
						});
					$apns->send_queue;
				}	
			}

			# Check for devices that don't want notifications any more
			if (time - $last_feedback > 3600) {
				syslog(LOG_INFO, 'Check APNS feedback service');
				$last_feedback = time;
				my $apns_feedback = Net::APNS::Feedback->new({
					sandbox => 0,
					cert => $apns_cert,
					key => $apns_key
				});
				my $feedback =  $apns_feedback->retrieve_feedback;
				$apns_feedback->disconnect;
	
				if (defined $feedback) {
					# Got at least one value
					foreach (@$feedback) {
						my $feedback_token = lc($$_{token});
						my $feedback_time = $$_{time_t};
						foreach my $username (keys %devices) {
							my @unregister;	
							foreach (@{$devices{$username}}) {
								my ($aps_acct_id, $aps_dev_token, $aps_sub_topic, $time) = split /,/;
								if ($aps_dev_token eq $feedback_token && $time < $feedback_time) {
									# Hasn't registered since the rejection; unregister
									push @unregister, $feedback_token
								}
							}
							foreach my $token (@unregister) {
								syslog(LOG_INFO, "Unregister device $token");
								@{$devices{$username}} = grep {!/$token/} @{$devices{$username}};
							}
						}
					}
					save_devices;
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
