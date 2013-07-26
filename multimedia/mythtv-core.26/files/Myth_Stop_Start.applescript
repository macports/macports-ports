(*  Applescript to stop/start Myth background apps
For use with MacPorts install of Myth
Author:  Craig Treleaven, ctreleaven at cogeco.ca
Version: 0.26
Modified: 2012Jul11 - new
           2012Sep21 - log rotation
           2013Mar06 - .26, log server

NB - if mythbackend or mythlogserver is running, we only stop it if it was launched under launchd
*)
property MPprefix : "@PREFIX@"
set mysqld to " not running on this machine.  Is it on another machine on your network?"
set rotatorStatus to ""
set logrotButton to ""
set mythbackend to ""
set mythbackendButton to "Donno"
set newline to "
"
set indent to space & space & space & space
set lineStart to newline & indent & "= "
set myResult to ""

repeat until myResult is false
    set launchdList to (do shell script "sudo launchctl list" with administrator privileges)
    if launchdList contains ".logrotate" then
        set rotatorStatus to "runs daily"
        set logrotButton to "Disable log rotation"
    else
        set rotatorStatus to "is not scheduled"
        set logrotButton to "Schedule log rotation"
    end if
    
    set processes to do shell script "ps -Ac"
    if the processes contains "mysqld" then
        set mysqld to "running."
    end if
    
    if the processes contains "mythbackend" then
        set mythbackend to "running."
        set mythbackendButton to "Stop MythBackend"
        try
            do shell script "mythshutdown --check"
        on error
            set mythbackend to " running but busy with something.  Are you sure you want to shut down now?"
        end try
    else
        set mythbackend to "not running."
        set mythbackendButton to "Start MythBackend"
    end if
    
    set myResult to choose from list {logrotButton, mythbackendButton} Â
        with title "Stop/Start Myth-related programs" with prompt Â
        newline & "MacPorts tool to start and stop Myth's background processes" & Â
        newline & newline & "Currently... " & Â
        lineStart & "MySQL is É " & mysqld & newline & Â
        lineStart & "Log rotation É " & rotatorStatus & Â
        lineStart & "MythBackend is É " & mythbackend & newline Â
        OK button name "Modify Selected Process" cancel button name "Close"
    
    if myResult contains "Start MythBackend" then
        do shell script "sudo launchctl load -w /Library/LaunchDaemons/org.mythtv.mythlogserver.plist" with administrator privileges
        do shell script "sudo launchctl load -w /Library/LaunchDaemons/org.mythtv.mythbackend.plist" with administrator privileges
        delay 3
    else if myResult contains "Stop MythBackend" then
        if (launchdList contains ".mythbackend") then
            do shell script "sudo launchctl unload -w /Library/LaunchDaemons/org.mythtv.mythbackend.plist" with administrator privileges
            do shell script "sudo launchctl unload -w /Library/LaunchDaemons/org.mythtv.mythlogserver.plist" with administrator privileges
            delay 4
            -- there is a longish delay while myth closes down.
        else
            display alert " MythBackend appears not to have been started in the normal fashion.  Unable to shut down." message "Was mythbackend started directly from a command line session?" as warning
        end if
        --set myResult to "Close"
        
    else if myResult contains "Schedule log rotation" then
        if (FileExists(MPprefix & "/etc/logrotate.conf") and Â
            FileExists(MPprefix & "/etc/logrotate.d/logrotate.mythtv")) and Â
            FileExists("/Library/LaunchDaemons/org.macports.logrotate.plist") then
            do shell script "sudo launchctl load -w /Library/LaunchDaemons/org.macports.logrotate.plist" with administrator privileges
            delay 1
        else
            display dialog "logrotate is not configured.  Please see http://www.mythtv.org/wiki/MacPorts for instructions." buttons {"Close"}
        end if
    else if myResult contains "Disable log rotation" then
        do shell script "sudo launchctl unload -w /Library/LaunchDaemons/org.macports.logrotate.plist" with administrator privileges
        delay 1
    end if
end repeat

on FileExists(theFile) -- (String) as Boolean
    tell application "System Events" to return (exists file theFile)
end FileExists
