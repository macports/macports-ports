(*  Applescript to run 'Unix' version of mythtv-setup
For use with MacPorts install of Myth
Author:  Craig Treleaven, ctreleaven at cogeco.ca
Myth Version: 0.27.0
Modified: 2012May17
          2012Sep08 Force working themepainter
          2013Sep25 revert logserver stuff, themepainter no longer necessary

*)
property MSUappPath : "@PREFIX@/bin/mythtv-setup"
property MSUlogArg : "--logpath @MYTHTVLOGDIR@"
property MSUlogLevel : "info" -- single string
property MSUverboseLevel : {"general"} -- a list, can be multiple strings

set welcome to "Initial setup of Myth is done through the mythtv-setup program.  

This includes defining where recordings and other media are stored, tuners and sources of listings data and scanning for available channels, etc.
 
"
--Should test if mythbackend is running and warn user...

try
	set Clicked to display dialog welcome with title ¬
		"Run mythtv-setup" buttons {"Cancel", "Start"} default button "Start"
on error
	set Clicked to false
end try

set CmdList to {MSUappPath, MSUlogArg, "--loglevel " & MSUlogLevel, "--verbose " & joinlist(MSUverboseLevel, ",")}
set Cmd to (joinlist(CmdList, " "))
--display alert button returned of Clicked

if Clicked is not false then
	if button returned of Clicked = "Start" then
		--display alert Cmd
		do shell script Cmd -- run it!
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
