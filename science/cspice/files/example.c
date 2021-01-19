// SPICE usage example
// compile with:
// cc example.c -I/opt/local/include -L/opt/local/lib -lcspice -lm

#include <stdio.h>
#include <CSPICE/SpiceUsr.h>

int main() {

char utcstr[64];

// load Leap Seconds kernel, needed for time conversion, get from
// http://naif.jpl.nasa.gov/pub/naif/generic_kernels/lsk/naif0011.tls
furnsh_c("naif0011.tls");

// convert "0.0" to Julian Time
et2utc_c(0., "J", 14, 25, utcstr);
printf("%s\n",utcstr);

// convert "0.0" to ISOC (UTC) time string
et2utc_c(0., "ISOC", 14, 64, utcstr);
printf("%s\n",utcstr);

}

