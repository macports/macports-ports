#----------------------------------------------------------------------
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#----------------------------------------------------------------------
#
# GPL-licensed icons used by the .app created from this script are
# courtesy of KMyMoney's developers and taken from KMyMoney's sources.
# (See ../Portfile for details.)
#
#----------------------------------------------------------------------
#
# Authors:
#  - Brad Giesbrecht <brad@pixilla.com>
#  - Marko K"aning <MK-MacPorts@techno.ms>
#
#----------------------------------------------------------------------

try
	
	set userID to do shell script "stat -f '%Su' $HOME"
	
end try

set executable to "__PREFIX__/bin/kmymoney" as string
set kmymoney to (POSIX file executable)

try
	
	get alias kmymoney
	
on error
	
	display alert "There was an error locating KMyMoney's executable." & return & return & "Try 'port installed kmymoney' to verify that port 'kmymoney' is installed." & return & return & "The file we tried to find was:" & return & return & "'" & executable & "'" as warning
	return
	
end try

set command to ""

set kdedirID to ""
set qtdirID to ""
set ICEauthorityID to ""
set XauthorityID to ""

set kdeDir to (POSIX path of (path to home folder) & ".kde/" as string)
set qtDir to (POSIX path of (path to home folder) & ".qt/" as string)
set ICEauthority to (POSIX path of (path to home folder) & ".ICEauthority" as string)
set Xauthority to (POSIX path of (path to home folder) & ".Xauthority" as string)

set kdeDirMessage to ""
set qtDirMessage to ""
set ICEauthorityMessage to ""
set XauthorityMessage to ""

try
	
	POSIX file kdeDir as alias
	set kdedirID to do shell script "stat -f '%Su' $HOME/.kde"
	
end try

try
	
	POSIX file qtDir as alias
	set qtdirID to do shell script "stat -f '%Su' $HOME/.qt"
	
end try

try
	POSIX file ICEauthority as alias
	set ICEauthorityID to do shell script "stat -f '%Su' $HOME/.ICEauthority"
	
end try

try
	
	POSIX file Xauthority as alias
	set XauthorityID to do shell script "stat -f '%Su' $HOME/.Xauthority"

end try

if ((not kdedirID is equal to "") and not kdedirID = userID) or ((not qtdirID is equal to "") and not qtdirID = userID) or ((not ICEauthorityID is equal to "") and not ICEauthorityID = userID) or ((not XauthorityID is equal to "") and not XauthorityID = userID) then
	
	if (not kdedirID is equal to "") then set kdeDirMessage to (kdeDir & return & " is owned by " & kdedirID & return & return)
	if (not qtdirID is equal to "") then set qtDirMessage to (qtDir & return & " is owned by " & qtdirID & return & return)
	if (not ICEauthorityID is equal to "") then set ICEauthorityMessage to (ICEauthority & return & " is owned by " & ICEauthorityID & return & return)
	if (not XauthorityID is equal to "") then set XauthorityMessage to (Xauthority & return & " is owned by " & XauthorityID & return & return)
	
	set fixPermissions to button returned of (display dialog (kdeDirMessage & qtDirMessage & ICEauthorityMessage & XauthorityMessage & "They should be owned by " & userID & " for KMyMoney to run properly!") buttons {"Cancel", "Fix"} default button {"Fix"} with icon 2)
	
	if fixPermissions = "Fix" then
		
		if (not kdedirID is equal to "") then do shell script "chown -R " & userID & " " & kdeDir with administrator privileges
		if (not qtdirID is equal to "") then do shell script "chown -R " & userID & " " & qtDir with administrator privileges
		if (not ICEauthorityID is equal to "") then do shell script "chown " & userID & " " & ICEauthority with administrator privileges
		if (not XauthorityID is equal to "") then do shell script "chown " & userID & " " & Xauthority with administrator privileges
		
	end if
	
end if


set command to "sh -l -c " & (POSIX path of kmymoney) & " > /dev/null 2>&1"

try
	
	do shell script command
	
on error
	
	display alert "There was an error launching KMyMoney." & return & return & "Try 'port installed kmymoney' to verify that port 'kmymoney' is installed." & return & return & "The command we tried to execute was:" & return & return & "'" & command & "'" as warning
	
end try
