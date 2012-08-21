(*  Applescript to run 'Unix' version of mythfronted
For use with MacPorts install of Myth
Author:  Craig Treleaven, ctreleaven at cogeco.ca
Version: 0.25.0
Modified: 2012May15

*)
property MFEappPath : "@PREFIX@/bin/mythfrontend"
property MFElogArg : "--logpath @MYTHTVLOGDIR@"
property MFElogLevel : "info" -- single string
property MFEverboseLevel : {"none", "general"} -- a list, can be multiple strings

set CmdList to {MFEappPath, MFElogArg, "--loglevel " & MFElogLevel, "--verbose " & joinlist(MFEverboseLevel, ",")}
set Cmd to (joinlist(CmdList, " "))

do shell script Cmd & " &" -- run it!

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
