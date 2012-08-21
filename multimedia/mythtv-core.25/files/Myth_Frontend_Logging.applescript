(*  Applescript to select verbosity level of Myth Frontend
For use with MacPorts install of Myth
Author:  Craig Treleaven, ctreleaven at cogeco.ca
Myth Version: 0.25.2
Modified: 2012MAug10 - script path in compiled app

*)

set MFEscriptPath to "@APPLICATIONS_DIR@/MythTV/Myth_Frontend.app/Contents/Resources/Scripts/main.scpt"
set MFEscript to load script MFEscriptPath
--display dialog (MFEverboseLevel of MFEscript)

set verbose_list to {"none", "all", "most", "audio", "channel", "database", "decode", "file", "frame", "general", "gpuvideo", "gui", "libav", "network", "osd", "playback", "process", "schedule", "system", "timestamp", "upnp", "vbi"}
set level_list to {"emerg", "alert", "crit", "err", "warning", "notice", "info", "debug"}

--special: all, most
set verbose_selected to choose from list verbose_list with title "Verbose setting" with prompt "Choose one or more areas for focused logging.  General is the default" default items "general" with multiple selections allowed

if (count of verbose_selected) > 1 then
	if verbose_selected contains "all" then
		set verbose_selected to {"all"}
	else if verbose_selected contains "most" then
		set verbose_selected to {"most"}
	end if
end if

if verbose_selected is not false then
	set (MFEverboseLevel of MFEscript) to verbose_selected
	store script MFEscript in POSIX file MFEscriptPath with replacing
end if

set level_selected to choose from list level_list with title "Logging depth" with prompt "choose how extensively to log.  Info is the Myth default; I find warning adequate." default items "warning" without multiple selections allowed

if level_selected is not false then
	set (MFElogLevel of MFEscript) to level_selected
	store script MFEscript in POSIX file MFEscriptPath with replacing
end if

set theParams to "--verbose " & joinlist(verbose_selected, ",") & " --loglevel " & level_selected
display dialog ("From now on, Myth_Fontend will start the frontend using: " & theParams)

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

(*
Log levels
"emerg", "alert", "crit", "err", "warning", "notice", "info", "debug"
defaults to info
Full list of verbose options
{"none", "all", "most", "audio", "channel", "chanscan", "commflag", "database", "decode", "dsmcc", "dvbcam", "eit", "file", "frame", "general", "gpu", "gpuaudio", "gpuvideo", "gui", "idle", "jobqueue", "libav", "media", "mheg", "network", "osd", "playback", "process", "record", "refcount", "rplxqueue", "schedule", "siparser", "socket", "system", "timestamp", "upnp", "vbi", "xmltv"}
*)
