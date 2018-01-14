/*
 * Helper application which monitors network state and checks
 * the reachability of either pool.ntp.org or the host given
 * as the first argument.
 */

#include <CoreFoundation/CoreFoundation.h>
#include <SystemConfiguration/SystemConfiguration.h>
#include <syslog.h>

static void ntpReachabilityCallback (SCNetworkReachabilityRef target,
																		 SCNetworkConnectionFlags flags,
																		 void *info);

int main (int argc, const char * argv[])
{
	const char ntp_pool[] = "pool.ntp.org";
	const char *observed_host;
	if (argc > 1)
		observed_host = argv[1];
	else
		observed_host = ntp_pool;

	openlog ("chrony-netchanged", LOG_CONS | LOG_PID, LOG_DAEMON);

	SCNetworkReachabilityRef observedHost = SCNetworkReachabilityCreateWithName (NULL, observed_host);

	if (observedHost == NULL)
	{
		syslog (LOG_ERR, "Error creating reachability reference.");
		goto bail;
	}

	if (!SCNetworkReachabilitySetCallback(observedHost, ntpReachabilityCallback, NULL))
	{
		syslog (LOG_ERR, "Unable to set reachability callback.");
		goto bail;
	}

	if (!SCNetworkReachabilityScheduleWithRunLoop(observedHost, CFRunLoopGetCurrent(), kCFRunLoopCommonModes))
	{
		syslog (LOG_ERR, "Unable to schedule run loop monitoring on run loop.");
		goto bail;
	}

	syslog (LOG_NOTICE, "Observing %s.", observed_host);

	CFRunLoopRun ();

bail:
	if (observedHost)
		CFRelease (observedHost);

	closelog();

	return EXIT_FAILURE;
}

static void ntpReachabilityCallback(SCNetworkReachabilityRef target,
																		SCNetworkConnectionFlags flags,
																		void *info)
{
	if ((flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired))
	{
		syslog (LOG_NOTICE, "Link is online. Signalling chronyd to start sampling servers.");
		system (PREFIX "/etc/chrony/chrony-netchange online");
	}
	else
	{
		syslog (LOG_NOTICE, "Link is offline. Signalling chronyd to stop sampling servers.");
		system (PREFIX "/etc/chrony/chrony-netchange offline");
	}
}
