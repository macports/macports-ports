if [ -x __PREFIX__/bin/xset ] ; then
        fontpath="__PREFIX__/share/fonts/misc/,__PREFIX__/share/fonts/TTF/,__PREFIX__/share/fonts/OTF,__PREFIX__/share/fonts/Type1/,__PREFIX__/share/fonts/75dpi/:unscaled,__PREFIX__/share/fonts/100dpi/:unscaled,__PREFIX__/share/fonts/75dpi/,__PREFIX__/share/fonts/100dpi/,__PREFIX__/share/fonts/libwmf,__PREFIX__/share/fonts/urw-fonts"

        [ -e "$HOME"/.fonts/fonts.dir ] && fontpath="$fontpath,$HOME/.fonts"
        [ -e "$HOME"/Library/Fonts/fonts.dir ] && fontpath="$fontpath,$HOME/Library/Fonts"
        [ -e /Library/Fonts/fonts.dir ] && fontpath="$fontpath,/Library/Fonts"
        [ -e /System/Library/Fonts/fonts.dir ] && fontpath="$fontpath,/System/Library/Fonts"

        __PREFIX__/bin/xset fp= "$fontpath"
        unset fontpath
fi
