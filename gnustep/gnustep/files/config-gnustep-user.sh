#!/bin/sh

# some fancy term output methods
have_tput=true
if [ $TERM = "vt100" ]
	then
	t_bold="tput smso"
	t_norm="tput rmso"
elif `echo $TERM | grep -q xterm`
	then
	t_bold="tput bold"
	t_norm="tput sgr0"
else
	have_tput=false
fi
if $have_tput
	then
	t_clear="tput clear"
	$t_clear
fi

$t_clear

. /opt/local/GNUstep/System/Library/Makefiles/GNUstep.sh

$t_bold
echo
echo "Welcome to the G E C H S C U"
$t_norm
echo
echo "(GNUstep environment configuration helper script for the common user)"

sleep 2

echo
echo

#
# ask for timezone
#
echo
echo
echo "Please enter your timezone"
echo -n 'or type "list" for a list of available zones or "enter" : '
read
zone=${REPLY:-false}
if [ $zone != false ]
	then
	if [ $zone = "list" ]
		then
		cat $GNUSTEP_SYSTEM_ROOT/Library/Libraries/gnustep-base/Versions/1.14/Resources/NSTimeZones/regions | awk '{print $2}' | more
		echo
		echo -n 'you can enter timezone right now or "enter" to continue : '
		read
		zone=${REPLY:-false}
	fi
fi
if [ $zone != false ]
	then
	$t_bold
	if ! `grep -q $zone $GNUSTEP_SYSTEM_ROOT/Library/Libraries/gnustep-base/Versions/1.14/Resources/NSTimeZones/regions`
		then
		echo "$zone is not a recognized region name"
		zone=false
	else
		echo Timezone = $zone
	fi
	$t_norm
fi

echo
echo

if [ ! -d $GNUSTEP_USER_ROOT/Library/WindowMaker ]
	then
	echo -n "Installing WindowMaker resources ... "
	mkdir $GNUSTEP_USER_ROOT
	wmaker.inst
	echo "Done"
fi
echo "Setting AntiAliased text in WindowMaker"
def=$GNUSTEP_USER_ROOT/Defaults/WindowMaker
sed '/AntialiasedText/ s/NO/YES/' $def > $def.new
mv -f $def.new $def

echo
echo

echo "Setting some GNUstep environment defaults ... "
sleep 2
echo "System fonts    : Bitstream Vera"
gdefaults write NSGlobalDomain NSFont 'BitstreamVeraSans-Roman'
gdefaults write NSGlobalDomain NSBoldFont 'BitstreamVeraSans-Bold'
gdefaults write NSGlobalDomain NSItalicFont 'BitstreamVeraSans-Oblique'
gdefaults write NSGlobalDomain NSBoldItalicFont 'BitstreamVeraSans-BoldOblique'
gdefaults write NSGlobalDomain NSUserFixedPitchFont 'BitstreamVeraSansMono-Roman'
sleep 2
echo "Font size       : 10"
gdefaults write NSGlobalDomain NSFontSize '10'

if [ $zone != false ]
	then
	sleep 2
    echo "Local Time Zone : $zone"
	gdefaults write NSGlobalDomain "Local Time Zone" $zone
fi

sleep 2
echo "XShm            : disabled"
gdefaults write NSGlobalDomain XWindowBufferUseXShm NO

sleep 2
bundledir="$GNUSTEP_SYSTEM_ROOT/Library/Bundles"
echo "Resetting GSAppKitUserBundles (in NSGlobalDomain)"
defaults write NSGlobalDomain GSAppKitUserBundles "($bundledir/Camaelon.themeEngine, $bundledir/EtoileMenus.bundle, $bundledir/EtoileBehavior.bundle)"
sleep 2
echo "Setting User Interface Theme to Nesedah (in Camaelon domain)"
gdefaults write Camaelon Theme Nesedah

defaults write GWorkspace NoWarnOnQuit YES
defaults write NSGlobalDomain GSWorkspaceApplication "NotExist.app"

echo

sleep 2
echo
echo "All done !"


sleep 2
echo
echo "Note that even though the GNUstep environment is set"
sleep 2
echo "You may need to reset it if you experience DYLD errors when trying to start a GNUstep app"
sleep 2
echo "You can do so with '. $GNUSTEP_SYSTEM_ROOT/Library/Makefiles/GNUstep.sh'"
sleep 2

echo
echo
echo "Have a nice day !"

echo
echo
