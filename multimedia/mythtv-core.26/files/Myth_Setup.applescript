(*  Applescript to run 'Unix' version of mythtv-setup
For use with MacPorts install of Myth
Author:  Craig Treleaven, ctreleaven at cogeco.ca
Myth Version: 0.26
Modified: 2012May17
          2012Sep08 Force working themepainter
          2013Mar05 .26, start mythlogserver if not already running
*)
property MSUappPath : "@PREFIX@/bin/mythtv-setup"
property MSUlogArg : "-O ThemePainter=qt --logpath @MYTHTVLOGDIR@"
property MSUlogLevel : "info" -- single string
property MSUverboseLevel : {"general"} -- a list, can be multiple strings

property MLSappPath : "@PREFIX@/bin/mythlogserver"
property MLSlogArg : "--quiet --logpath @MYTHTVLOGDIR@"
property MLSlogLevel : "info" -- single string
property MLSverboseLevel : {"system", "general"} -- a list, can be multiple strings
set MLSpid to false

set welcome to "Initial setup of Myth is done through the mythtv-setup program.  

This includes defining where recordings and other media are stored, tuners and sources of listings data and scanning for available channels, etc.
 
"
--Should test if mythbackend is running and warn user...

if (do shell script "ps -Ac") does not contain "mythlogserver" then
    set MLScmd to joinlist({MLSappPath, MLSlogArg, "--loglevel " & MLSlogLevel, Â
        "--verbose " & joinlist(MLSverboseLevel, ","), ">& /dev/null & echo $!"}, " ")
    --display dialog MLScmd
    set MLSpid to do shell script MLScmd
end if

try
    set Clicked to display dialog welcome with title Â
        "Run mythtv-setup" buttons {"Cancel", "Start"} default button "Start"
on error
    set Clicked to false
end try

set CmdList to {MSUappPath, MSUlogArg, "--loglevel " & MSUlogLevel, "--verbose " & joinlist(MSUverboseLevel, ",")}
set Cmd to (joinlist(CmdList, " "))
--display alert button returned of Clicked

if Clicked is not false then
    if button returned of Clicked = "Start" then
        --display alert "mythtv-setup: " & Cmd
        do shell script Cmd -- run it!
    end if
end if

if MLSpid is not false then
    --display dialog "Kill: " & MLSpid
    do shell script "kill " & MLSpid
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
