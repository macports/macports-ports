if [ -x /usr/X11/bin/xset ] ; then
        fontpath="/usr/X11/lib/X11/fonts/misc/,/usr/X11/lib/X11/fonts/TTF/,/usr/X11/lib/X11/fonts/OTF,/usr/X11/lib/X11/fonts/Type1/,/usr/X11/lib/X11/fonts/75dpi/:unscaled,/usr/X11/lib/X11/fonts/100dpi/:unscaled,/usr/X11/lib/X11/fonts/75dpi/,/usr/X11/lib/X11/fonts/100dpi/"

        [ -e "$HOME"/.fonts/fonts.dir ] && fontpath="$fontpath,$HOME/.fonts"
        [ -e "$HOME"/Library/Fonts/fonts.dir ] && fontpath="$fontpath,$HOME/Library/Fonts"
        [ -e /Library/Fonts/fonts.dir ] && fontpath="$fontpath,/Library/Fonts"
        [ -e /System/Library/Fonts/fonts.dir ] && fontpath="$fontpath,/System/Library/Fonts"

        /usr/X11/bin/xset fp= "$fontpath"
        unset fontpath
fi
