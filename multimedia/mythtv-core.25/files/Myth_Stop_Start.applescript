(*  Applescript to stop/start Myth background apps
For use with MacPorts install of Myth
Author:  Craig Treleaven, ctreleaven at cogeco.ca
Version: 0.25.2
Modified: 2012Jul11 - new
           2012Sep21 - log rotation

NB - if mbe is running, we only stop it if it was launched under launchd
*)
set mysqld to " not running on this machine.  Is it on another machine on your network?"
set rotatorStatus to ""
set logrotButton to ""
set mythbackend to ""
set mythbackendButton to "Donno"
set newline to "
"
set indent to space & space & space & space
set myResult to ""

repeat until (myResult contains "Close")
	if (do shell script "sudo launchctl list" with administrator privileges) contains ".logrotate" then
		set rotatorStatus to "runs daily"
		set logrotButton to "Disable log rotation"
	else
		set rotatorStatus to "is not scheduled"
		set logrotButton to "Schedule log rotation"
	end if
	
	set processes to do shell script "ps -Ac"
	if the processes contains "mysqld" then
		set mysqld to " running."
	end if
	
	if the processes contains "mythbackend" then
		set mythbackend to " running."
		set mythbackendButton to "Stop MythBackend"
		try
			do shell script "mythshutdown --check"
		on error
			set mythbackend to " running but busy with something.  Are you sure you want to shut down now?"
		end try
	else
		set mythbackend to " not running."
		set mythbackendButton to "Start MythBackend"
	end if
	
	set myResult to display dialog newline & "Simple tool to start and stop Myth's background processes" & Â
		newline & newline & newline & "Currently... " & Â
		newline & newline & indent & "Log rotation " & rotatorStatus & Â
		newline & newline & indent & "MySQL is" & mysqld & Â
		newline & newline & indent & "MythBackend is" & mythbackend & newline & newline Â
		with icon note with title Â
		"Stop/Start Myth-related programs" buttons {logrotButton, mythbackendButton, "Close"} Â
		default button "Close" -- cancel button "Close" 
	set myResult to button returned of myResult
	if myResult contains "Start MythBackend" then
		do shell script "sudo launchctl load -w /Library/LaunchDaemons/org.mythtv.mythbackend.plist" with administrator privileges
	else if myResult contains "Stop MythBackend" then
		if ((do shell script "sudo launchctl list" with administrator privileges) contains "mythbackend") then
			do shell script "sudo launchctl unload -w /Library/LaunchDaemons/org.mythtv.mythbackend.plist" with administrator privileges
			-- there is a longish delay while myth closes down.
		else
			display alert " MythBackend appears not to have been started in the normal fashion.  Unable to shut down." message "Was mythbackend started directly from a command line session?" as warning
		end if
		set myResult to "Close"
	else if myResult contains "Schedule log rotation" then
		--check for existence of 
		if (FileExists("@PREFIX@/etc/logrotate.conf") and Â
			FileExists("@PREFIX@/etc/logrotate.d/logrotate.mythtv")) then
			do shell script "sudo launchctl load -w /Library/LaunchDaemons/org.macports.logrotate.plist" with administrator privileges
		else
			display dialog "logrotate is not configured.  Please see http://www.mythtv.org/wiki/MacPorts for instructions." buttons {"Close"}
			set myResult to "Close"
		end if
	else if myResult contains "Disable log rotation" then
		do shell script "sudo launchctl unload -w /Library/LaunchDaemons/org.macports.logrotate.plist" with administrator privileges
	end if
end repeat

on FileExists(theFile) -- (String) as Boolean
	tell application "System Events" to return (exists file theFile)
end FileExists
