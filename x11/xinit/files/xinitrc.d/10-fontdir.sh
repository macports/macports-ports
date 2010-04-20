if [ -x __PREFIX__/bin/xset ] ; then
        fontpath="__PREFIX__/lib/X11/fonts/misc/,__PREFIX__/lib/X11/fonts/TTF/,__PREFIX__/lib/X11/fonts/OTF,__PREFIX__/lib/X11/fonts/Type1/,__PREFIX__/lib/X11/fonts/75dpi/:unscaled,__PREFIX__/lib/X11/fonts/100dpi/:unscaled,__PREFIX__/lib/X11/fonts/75dpi/,__PREFIX__/lib/X11/fonts/100dpi/"

        [ -e "$HOME"/.fonts/fonts.dir ] && fontpath="$fontpath,$HOME/.fonts"
        [ -e "$HOME"/Library/Fonts/fonts.dir ] && fontpath="$fontpath,$HOME/Library/Fonts"
        [ -e /Library/Fonts/fonts.dir ] && fontpath="$fontpath,/Library/Fonts"
        [ -e /System/Library/Fonts/fonts.dir ] && fontpath="$fontpath,/System/Library/Fonts"

        __PREFIX__/bin/xset fp= "$fontpath"
        unset fontpath
fi
