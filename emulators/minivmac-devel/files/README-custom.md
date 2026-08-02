# Mini vMac Custom Variations

Mini vMac only offers limited control over its settings at runtime, and
changes to those settings don't persist after the program quits. Instead,
Mini vMac has a wide range of [options][options] that can be specified at
build time. The MacPorts Mini vMac ports expose a few of those options
using subports and variants, but for complete control, you can define your
own variations in the custom.conf file.

For each variation that you want MacPorts to compile, add a line with the
name of the variation between square brackets. Variation names should be
short and unique. Then add a line defining the options you want to use.
Finally, install the port:

    sudo port install minivmac-custom-devel

When you upgrade the port in the future, your custom variations will be
preserved. If you change the configuration file, you can rebuild the port to
reflect those changes immediately:

    sudo port -n upgrade --force minivmac-custom-devel

You should not specify the target (the `-t` option); MacPorts sets it for
you.

## Example Configuration File

For example, to compile a Macintosh Plus variation designed to be used in
fullscreen mode on a 15" MacBook Pro, and also a Macintosh II variation that
runs at quarter resolution and can be pixel-doubled to fill the screen,
your conf file might contain:

```
[1440x900 FS]
options = -hres 1440 -vres 900 -fullscreen 1 -var-fullscreen 0 \
          -mf 1 -gkf 0 -emm 0

[II 720x450]
options = -m II -hres 720 -vres 450 -gkf 0 -emm 0
```

## Variations Service

Instead of using MacPorts to compile custom variations, you can use the
Mini vMac developer's web-based [variations service][service].

## Donate

Consider [donating][donate] to offset the ongoing costs of developing and
supporting Mini vMac.

[options]: http://www.gryphel.org/c/minivmac/options.html#in
[service]: http://www.gryphel.org/c/minivmac/var_serv.html
[donate]: http://www.gryphel.org/c/wishlist/
