(*  Applescript to run 'Unix' version of mythfilldatabase
For use with MacPorts install of Myth
Author:  Craig Treleaven, ctreleaven at cogeco.ca
Myth Version: 0.27.0
Modified: 2012May17, 2013Sep25

*)
property MFDappPath : "@PREFIX@/bin/mythfilldatabase"
property MFDlogArg : "--logpath @MYTHTVLOGDIR@"
property MFDlogLevel : "warning" -- single string
property MFDverboseLevel : {"general"} -- a list, can be multiple strings

set welcome to "In a 'production' system, mythfilldatabase is run automatically by mythbackend at the times suggested by the listings source, usually daily.  

This applescript program allows you to run mythfilldatabase 'manually'; perhaps when Myth is first set up or if there are problems with the automatic runs. 
 
"

try
	set Clicked to display dialog welcome with title "Run mythfilldatabase" buttons {"Cancel", "Options", "Start Run"} default button "Start Run"
on error
	set Clicked to false
end try

set CmdList to {MFDappPath, MFDlogArg, "--loglevel " & MFDlogLevel, "--verbose " & joinlist(MFDverboseLevel, ",")}
set Cmd to (joinlist(CmdList, " "))
--display alert button returned of Clicked

if Clicked is not false then
	if button returned of Clicked = "Start Run" then
		do shell script Cmd -- run it!
	else if button returned of Clicked = "Options" then
		display alert "Options"
		-- let user select verbose and loglevel options
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
