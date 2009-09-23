-- $Id$

on run argv
	tell application "Finder"
		set the_path to item 1 of argv
		try
			-- Will throw an error if the_path does not exist.
			set the_item to POSIX file the_path as alias
			-- Will throw an error if the_item is not an alias.
			return POSIX path of (original item of the_item as text)
		end try
		return the_path
	end tell
end run
