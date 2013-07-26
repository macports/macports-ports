(*  Applescript to run 'Unix' version of mythfronted
For use with MacPorts install of Myth
Author:  Craig Treleaven, ctreleaven at cogeco.ca
Myth Version: 0.26
Modified: 2012May15
          2013Mar05 .26, start mythlogserver if not already running

*)
property MFEappPath : "@PREFIX@/bin/mythfrontend"
property MFElogArg : "--logpath @MYTHTVLOGDIR@"
property MFElogLevel : "info" -- single string
property MFEverboseLevel : {"none", "general"} -- a list, can be multiple strings

property MLSappPath : "@PREFIX@/bin/mythlogserver"
property MLSlogArg : "--quiet --logpath @MYTHTVLOGDIR@"
property MLSlogLevel : "info" -- single string
property MLSverboseLevel : {"system", "general"} -- a list, can be multiple strings
set MLSpid to false

if (do shell script "ps -Ac") does not contain "mythlogserver" then
    set MLScmd to joinlist({MLSappPath, MLSlogArg, "--loglevel " & MLSlogLevel, Â
        "--verbose " & joinlist(MLSverboseLevel, ","), ">& /dev/null & echo $!"}, " ")
    --display dialog MLScmd
    set MLSpid to do shell script MLScmd
end if

set CmdList to {MFEappPath, MFElogArg, "--loglevel " & MFElogLevel, "--verbose " & joinlist(MFEverboseLevel, ",")}
set Cmd to (joinlist(CmdList, " "))
--display alert Cmd
do shell script Cmd

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
