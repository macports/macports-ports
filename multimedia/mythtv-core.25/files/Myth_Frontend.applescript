(*  Applescript to run 'Unix' version of mythfronted
For use with MacPorts install of Myth
Author:  Craig Treleaven, ctreleaven at cogeco.ca
Version: 0.25.0
Modified: 2012May15
          2012Nov20 -- handle 'thread not shut down error' on exit, add --quiet to prevent 
            console output from being returned to AppleScript, allow experimental AirPlay

*)
property MFEappPath : "@PREFIX@/bin/mythfrontend"
property MFElogArg : "--logpath @MYTHTVLOGDIR@"
property MFElogLevel : "info" -- single string
property MFEverboseLevel : {"none", "general"} -- a list, can be multiple strings

set CmdList to {"AIRPLAY=\"1\"", MFEappPath, MFElogArg, "--loglevel " & MFElogLevel, "--verbose " & joinlist(MFEverboseLevel, ","), "--quiet"}
set Cmd to (joinlist(CmdList, " "))

try
	do shell script Cmd 
on error the error_message number the error_number
	if the error_number is not 133 then
		set the error_text to "Error: " & the error_number & ". " & the error_message
		display dialog the error_text buttons {"OK"} default button 1
		return the error_text
	end if
end try

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
