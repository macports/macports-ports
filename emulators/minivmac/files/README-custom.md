# Mini vMac Custom Variations

Mini vMac only offers limited control over its settings at runtime, and
changes to those settings don't persist after the program quits. Instead,
Mini vMac has a wide range of [options that can be specified at build
time](http://www.gryphel.org/c/minivmac/options.html#in). The MacPorts Mini
vMac ports expose a few of those options using subports and variants, but
for complete control, you can define your own variations in the custom.conf
file and install the minivmac-custom subport.

For each variation that you want MacPorts to compile, add a line with the
name of the variation between square brackets. Variation names should be
short and unique. Then add a line defining the options you want to use.

You should not specify the target (the `-t` option); MacPorts sets it for
you.

For example, to compile a Macintosh Plus variation designed to be used in
fullscreen mode on a 15" MacBook Pro, and also Macintosh II variation that
runs at quarter resolution and can be pixel-doubled to fill the screen,
your conf file might contain:

```
[1440x900 FS]
options = -hres 1440 -vres 900 -fullscreen 1 -var-fullscreen 0 \
          -mf 1 -gkf 0 -emm 0

[II 720x450]
options = -m II -hres 720 -vres 450 -gkf 0 -emm 0
```

To rebuild after you've made changes to the configuration file, use:

    sudo port -n upgrade --force minivmac-custom

If an error occurs during configuration, the Mini vMac 3.5.x build system
won't tell you what went wrong. This problem is fixed in Mini vMac 36.x,
which is available in the minivmac-custom-devel port.
