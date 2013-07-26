(*  Applescript to run 'Unix' version of mythfilldatabase
For use with MacPorts install of Myth
Author:  Craig Treleaven, ctreleaven at cogeco.ca
Myth Version: 0.26
Modified: 2012May17
          2013Mar06 .26, start mythlogserver if not already running

*)
property MFDappPath : "@PREFIX@/bin/mythfilldatabase"
property MFDlogArg : "--logpath @MYTHTVLOGDIR@"
property MFDlogLevel : "warning" -- single string
property MFDverboseLevel : {"general"} -- a list, can be multiple strings

property MLSappPath : "@PREFIX@/bin/mythlogserver"
property MLSlogArg : "--quiet --logpath @MYTHTVLOGDIR@"
property MLSlogLevel : "info" -- single string
property MLSverboseLevel : {"system", "general"} -- a list, can be multiple strings
set MLSpid to false

set welcome to "In a 'production' system, mythfilldatabase is run automatically by mythbackend at the times suggested by the listings source, usually daily.  

This applescript program allows you to run mythfilldatabase 'manually'; perhaps when Myth is first set up or if there are problems with the automatic runs. 
 
"

try
    set Clicked to display dialog welcome with title "Run mythfilldatabase" buttons {"Cancel", "Start Run"} default button "Start Run"
on error
    set Clicked to false
end try

if Clicked is not false then
    if button returned of Clicked = "Start Run" then
        if (do shell script "ps -Ac") does not contain "mythlogserver" then
            set MLScmd to joinlist({MLSappPath, MLSlogArg, "--loglevel " & MLSlogLevel, Â
                "--verbose " & joinlist(MLSverboseLevel, ","), ">& /dev/null & echo $!"}, " ")
            --display dialog MLScmd
            set MLSpid to do shell script MLScmd
            delay 1
        end if
        
        set CmdList to {MFDappPath, MFDlogArg, "--loglevel " & MFDlogLevel, "--verbose " & joinlist(MFDverboseLevel, ",")}
        set Cmd to (joinlist(CmdList, " "))
        --display alert Cmd
        do shell script Cmd -- run it!

        if MLSpid is not false then
            --display dialog "Kill: " & MLSpid
            do shell script "kill " & MLSpid
        end if

    end if
end if

-- -- -- -- -- -- -- -- 
-- Handlers
to joinlist(aList, delimiter)
    set retVal to ""
    set prevDelimiter to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delimiter
    set retVal to aList as string
    set AppleScript's text item delimiters to prevDelimiter
    return retVal
end joinlist
