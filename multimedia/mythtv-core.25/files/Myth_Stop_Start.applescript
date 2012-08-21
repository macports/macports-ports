(*  Applescript to stop/start Myth background apps
For use with MacPorts install of Myth
Author:  Craig Treleaven, ctreleaven at cogeco.ca
Version: 0.25.1
Modified: 2012Jul11

NB - if mbe is running, we only stop it if it was launched under launchd
*)
set mysqld to " not running on this machine.  Is it on another machine on your network?"
set mythbackend to ""
set mythbackendButton to "Donno"
--set mythmaintenance to " stopped."
set newline to "
"
set indent to space & space & space & space
set myResult to ""

repeat until (myResult contains "Close")
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
	
	set myResult to display dialog "Simple tool to start and stop some Myth's background processes" & newline & newline & "Currently... " & ¬
		newline & newline & indent & "MySQL is" & mysqld & ¬
		newline & indent & "MythBackend is" & mythbackend & newline ¬
		with icon note with title ¬
		"Stop/Start Myth-related programs" buttons {mythbackendButton, "Close"} ¬
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
	end if
end repeat
