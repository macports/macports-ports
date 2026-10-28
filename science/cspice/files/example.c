// SPICE usage example
// compile with:
// clang -I@PREFIX@/include -L@PREFIX@/lib -lcspice -o example example.c

#include <stdio.h>
#include <cspice/SpiceUsr.h>

int main(int argc, char* argv[]) {
  char utcstr[64];

  // load Leap Seconds kernel, needed for time conversion, get from
  // https://naif.jpl.nasa.gov/pub/naif/generic_kernels/lsk/naif0012.tls
  furnsh_c("@PREFIX@/share/doc/cspice/naif0012.tls");

  // convert "0.0" to Julian Time
  et2utc_c(0., "J", 14, 25, utcstr);
  printf("%s\n", utcstr);

  // convert "0.0" to ISOC (UTC) time string
  et2utc_c(0., "ISOC", 14, 64, utcstr);
  printf("%s\n", utcstr);

  return 0;
}
