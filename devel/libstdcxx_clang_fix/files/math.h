// -*- C++ -*-

// see https://github.com/macports/macports-ports/blob/master/lang/llvm-devel/files/0011-Fix-missing-long-long-math-prototypes-when-using-the.patch
// see https://trac.macports.org/ticket/61778

#ifndef __MACPORTS_MATH_H_FIX__
#define __MACPORTS_MATH_H_FIX__

#include_next <math.h>

#ifdef __clang__
// these prototypes are incorrectly omitted from <math.h> on Snow Leopard despite being available
extern "C" {
    extern long long int llrintl(long double);
    extern long long int llrint(double);
    extern long long int llrintf(float);

    extern long long int llroundl(long double);
    extern long long int llround(double);
    extern long long int llroundf(float);
}
#endif

#endif
