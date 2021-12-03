# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

# This portgroup provides a central place for managing an optional run-time
# dependency for the Yelp help browser. Yelp requires webkit2-gtk, which
# is not available on all platforms.

proc yelp.add_dependencies {} {
    global os.platform os.major subport

    if { ([variant_exists quartz] && [variant_isset quartz]) ||
         (${os.platform} eq "darwin" && ${os.major} <= 10) } {
        notes-append "
        ${subport} offers in-app documentation via Yelp, which is not available on
        your system. Some buttons or menu items related to Help may not work
        as expected."
    } else {
        depends_run-append port:yelp
    }
}

port::register_callback yelp.add_dependencies
